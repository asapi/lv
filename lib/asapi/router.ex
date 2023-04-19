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

  import Asapi.Util, only: [build_url: 2, redirect_to: 1]

  defmacro route(aar) do
    quote do: assign(var!(conn), :asapi_aar, unquote(aar))
  end

  use Trot.Router

  get "/:group/:name/+" do
    ext =
      case conn.assigns[:asapi_ext] do
        :html -> ""
        ext -> "@#{ext}"
      end

    conn
    |> build_url("/#{group}/#{name}#{ext}")
    |> redirect_to
  end

  get "/:g/:n" do
    route(%Aar{group: g, name: n})
  end

  get "/:g/:n/:v" do
    route(%Aar{group: g, name: n, revision: v})
  end

  get "/:g/:n/:v/:c" do
    route(%Aar{group: g, name: n, revision: v, classifier: c})
  end

  get "/*_path" do
    route(%Aar{group: nil, name: nil})
  end
end
