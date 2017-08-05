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
  use Asapi
  use Trot.Router
  use Trot.Template

  @template_root "priv/temp"


  get "/:group/:name/+/api.png" do
    {:redirect, "/#{group}/#{name}/api.png"}
  end

  get "/:g/:n/api.png" do
    %Aar{group: g, name: n}
    |> badge(:png)
  end

  get "/:g/:n/:v/api.png" do
    %Aar{group: g, name: n, version: v}
    |> badge(:png)
  end

  get "/:g/:n/:v/:c/api.png" do
    %Aar{group: g, name: n, version: v, classifier: c}
    |> badge(:png)
  end


  get "/:group/:name/+/api.svg" do
    {:redirect, "/#{group}/#{name}/api.svg"}
  end

  get "/:g/:n/api.svg" do
    %Aar{group: g, name: n}
    |> badge(:svg)
  end

  get "/:g/:n/:v/api.svg" do
    %Aar{group: g, name: n, version: v}
    |> badge(:svg)
  end

  get "/:g/:n/:v/:c/api.svg" do
    %Aar{group: g, name: n, version: v, classifier: c}
    |> badge(:svg)
  end


  get "/:group/:name/+/api.txt" do
    {:redirect, "/#{group}/#{name}/api.txt"}
  end

  get "/:g/:n/api.txt" do
    %Aar{group: g, name: n}
    |> api_lv
  end

  get "/:g/:n/:v/api.txt" do
    %Aar{group: g, name: n, version: v}
    |> api_lv
  end

  get "/:g/:n/:v/:c/api.txt" do
    %Aar{group: g, name: n, version: v, classifier: c}
    |> api_lv
  end


  get "/:group/:name/+" do
    {:redirect, "/#{group}/#{name}"}
  end

  get "/:g/:n" do
    %Aar{group: g, name: n}
    |> asapi_lv(conn)
  end

  get "/:g/:n/:v" do
    %Aar{group: g, name: n, version: v}
    |> asapi_lv(conn)
  end

  get "/:g/:n/:v/:c" do
    %Aar{group: g, name: n, version: v, classifier: c}
    |> asapi_lv(conn)
  end


  get "/*path" do
    no_aar = %Aar{group: nil, name: nil}
    case Enum.reverse(path) do
      ["api.png" | _] -> badge no_aar, :png
      ["api.svg" | _] -> badge no_aar, :svg
      ["api.txt" | _] -> api_lv no_aar
      _ -> asapi_lv no_aar, conn
    end
  end

  import_routes Trot.NotFound


  defp asapi_lv(%Aar{} = aar, conn) do
    path = case conn.request_path do
      "/" -> ""
      path -> path
    end
    render_template "asapi.html.eex",
      host: conn.host,
      path: path,
      lib: Aar.artifact(aar),
      api: api_lv(aar),
      loading: "#{shield(@loading)}.svg"
  end

  defp badge(%Aar{} = aar, type) do
    {:redirect, "#{shield(api_lv aar)}.#{type}"}
  end
end
