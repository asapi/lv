#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.TypeTest do
  use ExUnit.Case
  use Plug.Test
  alias Asapi.Type
  doctest Type

  test "init returns options unmodified" do
    assert Type.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call returns conn with state not :unset" do
    conn =
      conn(:get, "/foo")
      |> Map.put(:state, :set)
      |> put_private(:test, :value)

    assert Type.call(conn, nil) == conn
  end

  test "call sets html extension as default" do
    conn =
      conn(:get, "/foo")
      |> Type.call(nil)

    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == ["foo"]
  end

  test "call sets html extension as no extension" do
    conn =
      conn(:get, "/foo@")
      |> Type.call(nil)

    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == ["foo"]
  end

  test "call sets extension" do
    conn =
      conn(:get, "/foo@svg")
      |> Type.call(nil)

    assert conn.assigns[:asapi_ext] == :svg
    assert conn.path_info == ["foo"]
  end

  test "call sets first extension only" do
    conn =
      conn(:get, "/foo@txt@svg")
      |> Type.call(nil)

    assert conn.assigns[:asapi_ext] == :txt
    assert conn.path_info == ["foo"]
  end

  test "call removes empty path info" do
    conn =
      conn(:get, "/@html")
      |> Type.call(nil)

    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == []
  end
end
