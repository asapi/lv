#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Response do
  alias Plug.Conn
  alias Plug.Conn.Query

  import Plug.Conn

  def redirect_to(%Conn{} = conn, path, consumed \\ []) do
    uri =
      conn
      |> fetch_query_params
      |> Map.get(:query_params)
      |> Map.drop(consumed)
      |> Query.encode()
      |> case do
        "" -> path
        query -> "#{path}?#{query}"
      end

    conn
    |> put_resp_header("location", uri)
    |> send_resp(307, "")
  end

  def send_html(%Conn{} = conn, lib, api, loading) do
    body =
      EEx.eval_file(
        "priv/temp/asapi.html.eex",
        assigns: [
          host:
            case conn.port do
              80 -> conn.host
              443 -> conn.host
              port -> "#{conn.host}:#{port}"
            end,
          path:
            case Enum.join(conn.path_info, "/") do
              "" -> "/"
              path -> "/#{path}"
            end,
          lib: lib,
          api: api,
          loading: loading
        ]
      )

    conn
    |> send_resp(200, body)
  end

  def send_json(%Conn{} = conn, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end

  def send_text(%Conn{} = conn, text) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, text)
  end
end
