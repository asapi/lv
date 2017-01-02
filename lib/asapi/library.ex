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

defmodule Asapi.Library do
  @behaviour Plug
  import Plug.Conn
  import Trot.Router

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _) do
    conn |> fetch_query_params |> map_library
  end

  defp map_library(%Plug.Conn{query_params: %{"library" => lib}} = conn) do
    do_redirect "/" <> String.replace(lib, ":", "/"), conn
  end

  defp map_library(%Plug.Conn{} = conn) do
    conn
  end
end
