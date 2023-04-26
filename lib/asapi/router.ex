#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Router do
  use Plug.Router

  alias Asapi.Aar

  import Asapi.Response

  if Mix.env() == :prod do
    plug Plug.SSL, rewrite_on: [:x_forwarded_proto]
  else
    plug Plug.Logger
  end

  plug Plug.Static, at: "/", from: :asapi

  plug Asapi.Library
  plug Asapi.Type

  plug :match
  plug :dispatch

  plug Asapi.Reload
  plug Asapi.Lv

  get "/:group/:name/+" do
    ext =
      case conn.assigns[:asapi_ext] do
        :html -> ""
        ext -> "@#{ext}"
      end

    redirect_to(conn, "/#{group}/#{name}#{ext}")
  end

  defmacrop aar(fields) do
    quote do
      assign(var!(conn), :asapi_aar, struct(Aar, unquote(fields)))
    end
  end

  get "/:g/:n" do
    aar group: g, name: n
  end

  get "/:g/:n/:v" do
    aar group: g, name: n, revision: v
  end

  get "/:g/:n/:v/:c" do
    aar group: g, name: n, revision: v, classifier: c
  end

  get "/*_path" do
    aar group: nil, name: nil
  end
end
