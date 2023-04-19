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

defmodule Asapi.Reload do
  require Logger
  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data

  import Trot.Router, only: [do_redirect: 2]
  import Asapi.Util, only: [build_url: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{query_params: %{"reload" => _}} = conn, _opts) do
    conn
    |> clear_cached
    |> build_url(conn.request_path, ["reload"])
    |> do_redirect(conn)
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{group: nil}}} = conn), do: conn
  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{name: nil}}} = conn), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{} = aar}} = conn) do
    try do
      Data.clear!(aar)
    rescue
      error ->
        Logger.warn(Exception.message(error))
    end

    conn
  end

  defp clear_cached(%Conn{} = conn), do: conn
end
