#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

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
