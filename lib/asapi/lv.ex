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

defmodule Asapi.Lv do
  alias Asapi.Aar
  alias Asapi.Ext.Version
  require Logger
  use Asapi

  def api_lv(%Aar{group: nil}) do
    @unknown
  end

  def api_lv(%Aar{name: nil}) do
    @unknown
  end

  def api_lv(%Aar{} = aar) do
    aar
    |> Aar.resolve
    |> Aar.artifact
    |> aar_suffix
    |> String.replace(~R/@.*$/, "@aar")
    |> version_of
    |> case do
      nil -> @unknown
      lv -> lv
    end
  end

  defp aar_suffix(var) do
    "#{String.trim var}@aar"
  end

  defp version_of(artifact) do
    try do
      Version.of! artifact
    rescue error ->
      Logger.warn Exception.message error
      nil
    end
  end
end
