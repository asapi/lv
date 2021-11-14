#   asapi/lv
#   Copyright (C) 2017  tynn
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

defmodule Asapi.Ext.Data do
  alias Asapi.Aar
  alias Asapi.Ext.Repo
  alias Asapi.Ext.Redis

  def get!(%Aar{} = aar) do
    aar = resolved! aar
    Cachex.fetch! :lvc, aar, redis_get(&Repo.load!/1, 7)
  end

  defp resolved!(%Aar{} = aar) do
    if Repo.resolve? aar do
      rev = Cachex.fetch! :lvc, aar, redis_get(&Repo.resolve!/1, 1)
      %{aar | revision: rev}
    else
      aar
    end
  end

  defp redis_get(fallback, dtl) do
    &Redis.get!(&1, fallback, dtl)
  end

  def clear!(%Aar{} = aar) do
    Cachex.execute :lvc, &clear!(&1, {aar})
    nil
  end

  defp clear!(worker, {%Aar{}} = aar) do
    if Cachex.get_and_update! worker, aar, &clear?/1 do
      Cachex.expire! worker, aar, :timer.minutes(3)
      clear aar
    end
  end

  defp clear?(false), do: { :ignore, false }
  defp clear?(true), do: false
  defp clear?(nil), do: true

  defp clear({%Aar{} = aar}) do
    dyn = Repo.resolve? aar
    clear_redis(aar, dyn)
    |> clear_cache(aar, dyn)
  end

  defp clear_redis(aar, _ \\ false)

  defp clear_redis(%Aar{} = aar, false) do
    Redis.get_and_del! aar
  end

  defp clear_redis(%Aar{} = aar, true) do
    revision = clear_redis aar
    clear_redis %{aar | revision: revision}
    revision
  end

  defp clear_cache(rev, %Aar{} = aar, dyn) do
    Cachex.execute :lvc, &clear_cache(&1, aar, dyn, rev)
  end

  defp clear_cache(worker, aar, dyn \\ false, rev \\ nil)

  defp clear_cache(worker, %Aar{} = aar, false, _) do
    {_, revision} = Cachex.get worker, aar
    Cachex.del worker, aar
    revision
  end

  defp clear_cache(worker, %Aar{} = aar, true, rev) do
    revision = clear_cache worker, aar
    case rev do
      nil -> nil
      ^revision -> nil
      _ -> clear_cache worker, %{aar | revision: rev}
    end
    clear_cache worker, %{aar | revision: revision}
  end
end
