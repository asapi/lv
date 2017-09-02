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
  alias Plug.Conn

  import Asapi.Redirect, only: [build_url: 2, redirect_to: 1]


  use Trot.Router


  get "/:group/:name/+/api.png" do
    conn
    |> build_url("/#{group}/#{name}/api.png")
    |> redirect_to
  end

  get "/:g/api.png" do
    %Aar{group: g, name: nil}
    |> route(conn, :png)
  end

  get "/:g/:n/api.png" do
    %Aar{group: g, name: n}
    |> route(conn, :png)
  end

  get "/:g/:n/:v/api.png" do
    %Aar{group: g, name: n, revision: v}
    |> route(conn, :png)
  end

  get "/:g/:n/:v/:c/api.png" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> route(conn, :png)
  end


  get "/:group/:name/+/api.svg" do
    conn
    |> build_url("/#{group}/#{name}/api.svg")
    |> redirect_to
  end

  get "/:g/api.svg" do
    %Aar{group: g, name: nil}
    |> route(conn, :svg)
  end

  get "/:g/:n/api.svg" do
    %Aar{group: g, name: n}
    |> route(conn, :svg)
  end

  get "/:g/:n/:v/api.svg" do
    %Aar{group: g, name: n, revision: v}
    |> route(conn, :svg)
  end

  get "/:g/:n/:v/:c/api.svg" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> route(conn, :svg)
  end


  get "/:group/:name/+/api.txt" do
    conn
    |> build_url("/#{group}/#{name}/api.txt")
    |> redirect_to
  end

  get "/:g/api.txt" do
    %Aar{group: g, name: nil}
    |> route(conn, :txt)
  end

  get "/:g/:n/api.txt" do
    %Aar{group: g, name: n}
    |> route(conn, :txt)
  end

  get "/:g/:n/:v/api.txt" do
    %Aar{group: g, name: n, revision: v}
    |> route(conn, :txt)
  end

  get "/:g/:n/:v/:c/api.txt" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> route(conn, :txt)
  end


  get "/:group/:name/+" do
    conn
    |> build_url("/#{group}/#{name}")
    |> redirect_to
  end

  get "/:g/:n" do
    %Aar{group: g, name: n}
    |> route(conn, :html)
  end

  get "/:g/:n/:v" do
    %Aar{group: g, name: n, revision: v}
    |> route(conn, :html)
  end

  get "/:g/:n/:v/:c" do
    %Aar{group: g, name: n, revision: v, classifier: c}
    |> route(conn, :html)
  end


  get "/*path" do
    no_aar = %Aar{group: nil, name: nil}
    ext = case Enum.reverse(path) do
      ["api.png" | _] -> :png
      ["api.svg" | _] -> :svg
      ["api.txt" | _] -> :txt
      _ -> :html
    end
    route no_aar, conn, ext
  end


  defp route(%Aar{} = aar, %Conn{} = conn, ext) do
    conn
    |> assign(:asapi_aar, aar)
    |> assign(:asapi_ext, ext)
  end
end
