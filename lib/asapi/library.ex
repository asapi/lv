#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Library do
  alias Plug.Conn

  @behaviour Plug

  import Asapi.Response
  import Plug.Conn, only: [fetch_query_params: 1]

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Conn{} = conn, _opts) do
    conn
    |> fetch_query_params
    |> handle
  end

  defp handle(%Conn{query_params: %{"library" => lib}} = conn) do
    conn
    |> redirect_to("/#{String.replace(lib, ":", "/")}", ["library"])
  end

  defp handle(%Conn{} = conn), do: conn
end
