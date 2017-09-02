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

defmodule Asapi.Router do
  alias Asapi.Aar

  import Asapi
  import Asapi.Lv
  import Asapi.Redirect

  use Asapi
  use Trot.Router
  use Trot.Template

  @template_root "priv/temp"


  get "/:group/:name/+/api.png" do
    conn
    |> build_url("/#{group}/#{name}/api.png")
    |> redirect_to
  end

  get "/:g/api.png" do
    %Aar{group: g, name: nil}
    |> badge(conn, :png)
  end

  get "/:g/:n/api.png" do
    %Aar{group: g, name: n}
    |> badge(conn, :png)
  end

  get "/:g/:n/:v/api.png" do
    %Aar{group: g, name: n, revision: v}
    |> badge(conn, :png)
  end

  get "/:g/:n/:v/:c/api.png" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> badge(conn, :png)
  end


  get "/:group/:name/+/api.svg" do
    conn
    |> build_url("/#{group}/#{name}/api.svg")
    |> redirect_to
  end

  get "/:g/api.svg" do
    %Aar{group: g, name: nil}
    |> badge(conn, :svg)
  end

  get "/:g/:n/api.svg" do
    %Aar{group: g, name: n}
    |> badge(conn, :svg)
  end

  get "/:g/:n/:v/api.svg" do
    %Aar{group: g, name: n, revision: v}
    |> badge(conn, :svg)
  end

  get "/:g/:n/:v/:c/api.svg" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> badge(conn, :svg)
  end


  get "/:group/:name/+/api.txt" do
    conn
    |> build_url("/#{group}/#{name}/api.txt")
    |> redirect_to
  end

  get "/:g/api.txt" do
    %Aar{group: g, name: nil}
    |> api_lv(conn)
  end

  get "/:g/:n/api.txt" do
    %Aar{group: g, name: n}
    |> api_lv(conn)
  end

  get "/:g/:n/:v/api.txt" do
    %Aar{group: g, name: n, revision: v}
    |> api_lv(conn)
  end

  get "/:g/:n/:v/:c/api.txt" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> api_lv(conn)
  end


  get "/:group/:name/+" do
    conn
    |> build_url("/#{group}/#{name}")
    |> redirect_to
  end

  get "/:g/:n" do
    %Aar{group: g, name: n}
    |> asapi_lv(conn)
  end

  get "/:g/:n/:v" do
    %Aar{group: g, name: n, revision: v}
    |> asapi_lv(conn)
  end

  get "/:g/:n/:v/:c" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> asapi_lv(conn)
  end


  get "/*path" do
    no_aar = %Aar{group: nil, name: nil}
    case Enum.reverse(path) do
      ["api.png" | _] -> badge no_aar, conn, :png
      ["api.svg" | _] -> badge no_aar, conn, :svg
      ["api.txt" | _] -> api_lv no_aar, conn
      _ -> asapi_lv no_aar, conn
    end
  end

  import_routes Trot.NotFound


  defp redirect_to(url) do
    {:redirect, url}
  end


  defp reload(%Aar{} = aar, %Plug.Conn{} = conn) do
    conn
    |> invalidate(aar)
    |> build_url(conn.request_path, ["reload"])
    |> redirect_to
  end

  defp invalidate(%Plug.Conn{query_params: %{"reload" => _}} = conn, %Aar{} = aar) do
    clear aar
    conn
  end

  defp invalidate(%Plug.Conn{} = conn, %Aar{}) do
    conn
  end


  defp asapi_lv(%Aar{} = aar, %Plug.Conn{query_params: %{"reload" => _}} = conn) do
    reload aar, conn
  end

  defp asapi_lv(%Aar{} = aar, %Plug.Conn{} = conn) do
    path = case conn.request_path do
      "/" -> ""
      path -> path
    end
    render_template "asapi.html.eex",
      host: conn.host,
      path: path,
      lib: to_string(aar),
      api: api_lv(aar),
      loading: "#{shield(@loading)}.svg"
  end


  defp badge(%Aar{} = aar, %Plug.Conn{} = conn, type) do
    conn
    |> invalidate(aar)
    |> build_url("#{shield(api_lv aar)}.#{type}", ["reload"])
    |> redirect_to
  end


  defp api_lv(%Aar{} = aar, %Plug.Conn{query_params: %{"reload" => _}} = conn) do
    reload aar, conn
  end

  defp api_lv(%Aar{} = aar, %Plug.Conn{}) do
    api_lv aar
  end
end
