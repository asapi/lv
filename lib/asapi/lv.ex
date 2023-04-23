#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Lv do
  alias Plug.Conn
  alias Asapi.Aar
  alias Asapi.Ext.Data
  require Logger

  import Trot.Router, only: [make_response: 2]
  import Asapi.Util

  use Asapi
  use Trot.Template

  @template_root "priv/temp"

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{state: :unset} = conn, _opts) do
    conn
    |> asapi_lv
    |> make_response(conn)
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp asapi_lv(%Conn{assigns: %{asapi_aar: %Aar{} = aar, asapi_ext: :html}} = conn) do
    host =
      case conn.port do
        80 -> conn.host
        443 -> conn.host
        port -> "#{conn.host}:#{port}"
      end

    path =
      case Enum.join(conn.path_info, "/") do
        "" -> "/"
        path -> "/#{path}"
      end

    render_template("asapi.html.eex",
      host: host,
      path: path,
      lib: to_string(aar),
      api: api_lv(aar),
      loading: "#{shield(@loading)}.svg"
    )
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: type}} = conn)
       when type in [:png, :svg] do
    conn
    |> build_url("#{shield(api_lv(aar))}.#{type}")
    |> redirect_to
  end

  defp asapi_lv(%Conn{assigns: %{asapi_aar: aar, asapi_ext: :txt}}) do
    aar
    |> api_lv
    |> send_text
  end

  defp asapi_lv(%Conn{} = conn), do: conn

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
