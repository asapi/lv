#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.LibraryTest do
  use ExUnit.Case
  use Plug.Test
  alias Asapi.Library
  doctest Library

  test "init returns options unmodified" do
    assert Library.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call fetches query params" do
    conn =
      conn(:get, "/foo")
      |> put_private(:test, :value)
      |> Library.call(nil)

    assert conn.params == %{}
    assert conn.query_params == %{}
  end

  test "call returns conn without library param" do
    conn =
      conn(:get, "/foo")
      |> put_private(:test, :value)
      |> fetch_query_params

    assert Library.call(conn, nil) == conn
  end

  test "call redirects conn with library param" do
    conn =
      conn(:get, "/foo?library=bar")
      |> Library.call(nil)

    assert {"location", "/bar"} in conn.resp_headers
  end
end
