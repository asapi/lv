#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.RouterTest do
  use ExUnit.Case
  use Plug.Test
  import Mock
  alias Asapi.Aar
  alias Asapi.Router
  alias Asapi.Ext.Data
  doctest Router

  setup_with_mocks([{Data, [], [get!: fn _ -> "1+" end]}]) do
    :ok
  end

  test "redirect + rev to html generic path" do
    conn =
      conn(:get, "/foo/bar/+")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert {"location", "/foo/bar"} in conn.resp_headers
  end

  test "redirect + rev with ext to generic path" do
    conn =
      conn(:get, "/foo/bar/+@svg")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert {"location", "/foo/bar@svg"} in conn.resp_headers
  end

  test "route group and name" do
    conn =
      conn(:get, "/foo/bar")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert_aar(conn, "foo", "bar")
  end

  test "route group and name and revision" do
    conn =
      conn(:get, "/foo/bar/0.0")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert_aar(conn, "foo", "bar", "0.0")
  end

  test "route group and name and revision and classifier" do
    conn =
      conn(:get, "/foo/bar/0.0/baz")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert_aar(conn, "foo", "bar", "0.0", "baz")
  end

  test "route simple path with invalid aar" do
    conn =
      conn(:get, "/foo")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert_aar(conn, nil, nil)
  end

  test "route long path with invalid aar" do
    conn =
      conn(:get, "/foo/bar/0.0/baz/bat")
      |> Map.put(:scheme, :https)
      |> Router.call(nil)

    assert_aar(conn, nil, nil)
  end

  defp assert_aar(conn, g, n, r \\ nil, c \\ nil) do
    assert conn.assigns[:asapi_aar] ==
             %Aar{group: g, name: n, revision: r, classifier: c}
  end
end
