#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Lv do
  use Asapi.Shield

  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data

  @behaviour Plug

  require Logger

  import Asapi.Response

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Conn{state: :unset} = conn, _opts) do
    asapi_lv(conn)
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp asapi_lv(%Conn{assigns: %{asapi_aar: %Aar{} = aar, asapi_ext: :html}} = conn) do
    send_html(conn, to_string(aar), api_lv(aar), "#{shield(@loading)}.svg")
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: type}} = conn)
       when type in [:png, :svg] do
    redirect_to(conn, "#{shield(api_lv(aar))}.#{type}")
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: :json}} = conn) do
    send_json(conn, shield(api_lv(aar), json: true))
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: :txt}} = conn) do
    send_text(conn, api_lv(aar))
  end

  defp asapi_lv(conn), do: conn

  defp api_lv(%Aar{group: nil}), do: @unknown
  defp api_lv(%Aar{name: nil}), do: @unknown

  defp api_lv(%Aar{} = aar) do
    try do
      case Data.get!(aar) do
        nil -> @unknown
        lv -> lv
      end
    rescue
      error ->
        Logger.warn(Exception.message(error))
        @unknown
    end
  end
end
