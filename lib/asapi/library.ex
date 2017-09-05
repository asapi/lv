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
  alias Plug.Conn
  import Plug.Conn, only: [fetch_query_params: 1]
  import Trot.Router, only: [do_redirect: 2]
  import Asapi.Util, only: [build_url: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{} = conn, _opts) do
    conn
    |> fetch_query_params
    |> handle
  end

  defp handle(%Conn{query_params: %{"library" => lib}} = conn) do
    conn
    |> build_url("/#{String.replace lib, ":", "/"}", ["library"])
    |> do_redirect(conn)
  end

  defp handle(%Conn{} = conn), do: conn
end
