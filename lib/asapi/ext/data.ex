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
  alias Asapi.Ext.Redis
  import Asapi.Ext.Repo

  def get!(%Aar{} = aar) do
    aar = resolved! aar
    Cachex.get! :lvc, aar, from(&load!/1, 7)
  end

  defp resolved!(%Aar{} = aar) do
    if resolve? aar do
      rev = Cachex.get! :lvc, aar, from(&resolve!/1, 1)
      %{aar | revision: rev}
    else
      aar
    end
  end

  defp from(fallback, dtl) do
    [ fallback: &Redis.get!(&1, fallback, dtl) ]
  end


  def clear!(%Aar{} = aar) do
    Cachex.execute :lvc, &clear!(&1, {aar})
    nil
  end

  defp clear!(worker, {%Aar{}} = aar) do
    if Cachex.get_and_update! :lvc, aar, &is_nil/1, [ fallback: &clear/1 ] do
      Cachex.expire! worker, aar, :timer.minutes(3)
    end
  end


  defp clear({%Aar{} = aar}) do
    dyn = resolve? aar
    clear_redis(aar, dyn)
    |> clear_cache(aar, dyn)
    nil
  end


  defp clear_redis(aar, _ \\ false)

  defp clear_redis(%Aar{} = aar, true) do
    revision = clear_redis aar
    clear_redis %{aar | revision: revision}
    revision
  end

  defp clear_redis(%Aar{} = aar, _) do
    Redis.get_and_del! aar
  end


  defp clear_cache(rev, %Aar{} = aar, dyn) do
    Cachex.execute :lvc, &clear_cache(&1, aar, rev, dyn)
  end


  defp clear_cache(worker, aar, rev \\ nil, dyn \\ false)

  defp clear_cache(worker, %Aar{} = aar, rev, true) do
    clear_cache worker, %{aar | revision: rev}
    revision = clear_cache worker, aar
    clear_cache worker, %{aar | revision: revision}, rev
  end

  defp clear_cache(_, %Aar{revision: rev}, rev, _) do
    rev
  end

  defp clear_cache(worker, %Aar{} = aar, _, _) do
    {_, revision} = Cachex.get worker, aar
    Cachex.del worker, aar
    revision
  end
end
