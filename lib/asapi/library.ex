#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Library do
  alias Plug.Conn
  import Plug.Conn, only: [fetch_query_params: 1]
  import Trot.Router, only: [do_redirect: 2]
  import Asapi.Util, only: [build_url: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{} = conn, _opts) do
    conn
    |> fetch_query_params
    |> handle
  end

  defp handle(%Conn{query_params: %{"library" => lib}} = conn) do
    conn
    |> build_url("/#{String.replace(lib, ":", "/")}", ["library"])
    |> do_redirect(conn)
  end

  defp handle(%Conn{} = conn), do: conn
end
