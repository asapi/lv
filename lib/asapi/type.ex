#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Type do
  alias Plug.Conn

  import Plug.Conn, only: [assign: 3]

  @behaviour Plug

  def init(opts), do: opts

  def call(%Conn{state: :unset} = conn, _opts) do
    {last, ext} = split_ext(conn)

    conn
    |> assign(:asapi_ext, ext)
    |> Map.update!(:path_info, update_path_info(last))
  end

  def call(%Conn{} = conn, _opts), do: conn

  @stdext :html

  defp split_ext(%Conn{path_info: []}), do: {nil, @stdext}

  defp split_ext(%Conn{} = conn) do
    conn.path_info
    |> List.last()
    |> String.split("@")
    |> case do
      [last] -> {last, @stdext}
      [last, ""] -> {last, @stdext}
      [last, ext] -> {last, :"#{ext}"}
      [last, ext | _] -> {last, :"#{ext}"}
    end
  end

  defp update_path_info(""), do: &List.delete_at(&1, -1)
  defp update_path_info(last), do: &List.update_at(&1, -1, fn _ -> last end)
end
