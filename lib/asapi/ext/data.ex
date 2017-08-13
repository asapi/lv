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

  def resolve_rev!(%Aar{} = aar) do
    case aar.revision do
      nil -> true
      "" -> true
      "latest.integration" -> true
      "latest.milestone" -> true
      "latest.release" -> true
      rev -> String.ends_with?(rev, "+")
    end
    |> if do
      aar_rev! aar
    else
      aar
    end
  end

  defp aar_rev!(%Aar{} = aar) do
    rev = Cachex.get! :lvc, aar, [ fallback: &Repo.resolve/1 ]
    %{aar | revision: rev}
  end

  def load_artifact!(%Aar{} = aar) do
    Repo.load_artifact!(aar)
  end

  def sdk_levels!(%Aar{} = aar) do
    Cachex.get! :lvc, aar, [ fallback: &Aar.sdk_levels!/1 ]
  end
end
