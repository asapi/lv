#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Reload do
  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data

  @behaviour Plug

  require Logger

  import Asapi.Response

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Conn{query_params: %{"reload" => _}} = conn, _opts) do
    conn
    |> clear_cached
    |> redirect_to(conn.request_path, ["reload"])
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{group: nil}}} = conn), do: conn
  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{name: nil}}} = conn), do: conn

  defp clear_cached(%Conn{assigns: %{asapi_aar: %Aar{} = aar}} = conn) do
    try do
      Data.clear!(aar)
    rescue
      error -> Logger.warning(Exception.message(error))
    end

    conn
  end

  defp clear_cached(%Conn{} = conn), do: conn
end
