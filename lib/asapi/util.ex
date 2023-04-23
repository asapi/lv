#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Util do
  alias Plug.Conn
  import Plug.Conn, only: [fetch_query_params: 1]
  import Plug.Conn.Query, only: [encode: 1]

  def build_url(%Conn{} = conn, path, consumed \\ []) do
    conn
    |> fetch_query_params
    |> Map.get(:query_params)
    |> Map.drop(consumed)
    |> encode
    |> case do
      "" -> path
      query -> "#{path}?#{query}"
    end
  end

  def redirect_to(url), do: {:redirect, url}

  def send_text(text), do: {:ok, text, ["content-type": "text/plain"]}
end
