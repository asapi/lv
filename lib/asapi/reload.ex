#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Reload do
  require Logger
  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data

  import Trot.Router, only: [do_redirect: 2]
  import Asapi.Util, only: [build_url: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{query_params: %{"reload" => _}} = conn, _opts) do
    conn
    |> clear_cached
    |> build_url(conn.request_path, ["reload"])
    |> do_redirect(conn)
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{group: nil}}} = conn), do: conn
  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{name: nil}}} = conn), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{} = aar}} = conn) do
    try do
      Data.clear!(aar)
    rescue
      error ->
        Logger.warn(Exception.message(error))
    end

    conn
  end

  defp clear_cached(%Conn{} = conn), do: conn
end
