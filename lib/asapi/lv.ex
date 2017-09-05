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
  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data
  require Logger

  import Trot.Router, only: [make_response: 2]
  import Asapi.Util, only: [build_url: 3, redirect_to: 1]

  use Asapi
  use Trot.Template

  @template_root "priv/temp"


  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{state: :unset} = conn, _opts) do
    conn
    |> asapi_lv
    |> make_response(conn)
  end

  def call(%Conn{} = conn, _opts), do: conn


  defp asapi_lv(%Conn{assigns: %{asapi_aar: %Aar{} = aar, asapi_ext: :html}} = conn) do
    host = conn.port
    |> case do
      "" -> conn.host
      80 -> conn.host
      443 -> conn.host
      nil -> conn.host
      port -> "#{conn.host}:#{port}"
    end
    path = conn.path_info
    |> Enum.join("/")
    |> case do
      "" -> "/"
      path -> "/#{path}"
    end
    render_template "asapi.html.eex",
      host: host,
      path: path,
      lib: to_string(aar),
      api: api_lv(aar),
      loading: "#{shield(@loading)}.svg"
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: type}} = conn) when type in [:png, :svg] do
    conn
    |> build_url("#{shield(api_lv aar)}.#{type}", ["reload"])
    |> redirect_to
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: :txt}}) do
    api_lv aar
  end

  defp asapi_lv(%Conn{} = conn) do
    conn
  end


  defp api_lv(%Aar{group: nil}), do: @unknown
  defp api_lv(%Aar{name: nil}), do: @unknown

  defp api_lv(%Aar{} = aar) do
    try do
      case Data.get! aar do
        nil -> @unknown
        lv -> lv
      end
    rescue error ->
      Logger.warn Exception.message error
      @unknown
    end
  end
end
