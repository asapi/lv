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

defmodule Asapi.Type do
  alias Plug.Conn

  import Plug.Conn, only: [assign: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{state: :unset} = conn, _opts) do
    {last, ext} = split_ext conn
    conn
    |> assign(:asapi_ext, ext)
    |> Map.update!(:path_info, update_path_info(last))
  end

  def call(%Conn{} = conn, _opts), do: conn

  @stdext :html

  defp split_ext(%Conn{path_info: []}), do: {nil, @stdext}

  defp split_ext(%Conn{} = conn) do
    conn.path_info
    |> List.last
    |> String.split("@")
    |> case do
      [last] -> {last, @stdext}
      [last, ""] -> {last, @stdext}
      [last, ext] -> {last, :"#{ext}"}
      [last, ext | _] -> {last, :"#{ext}"}
    end
  end

  defp update_path_info(""), do: &List.delete_at(&1, -1)
  defp update_path_info(last), do: &List.update_at(&1, -1, fn _ -> last end)
end
