#   asapi/lv
#   Copyright (C) 2017  tynn
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.

defmodule Asapi.RouterTest do
  use ExUnit.Case
  use Plug.Test
  import Mock
  alias Asapi.Aar
  alias Asapi.Router
  alias Asapi.Ext.Data
  doctest Router

  setup_with_mocks([{ Data, [], [get!: fn _ -> "1+" end] }]) do
    :ok
  end

  test "redirect + rev to html generic path" do
    conn = conn(:get, "/foo/bar/+")
    |> Router.call(nil)
    assert {"location", "/foo/bar"} in conn.resp_headers
  end

  test "redirect + rev with ext to generic path" do
    conn = conn(:get, "/foo/bar/+@svg")
    |> Router.call(nil)
    assert {"location", "/foo/bar@svg"} in conn.resp_headers
  end

  test "route group and name" do
    conn = conn(:get, "/foo/bar")
    |> Router.call(nil)
    assert_aar conn, "foo", "bar"
  end

  test "route group and name and revision" do
    conn = conn(:get, "/foo/bar/0.0")
    |> Router.call(nil)
    assert_aar conn, "foo", "bar", "0.0"
  end

  test "route group and name and revision and classifier" do
    conn = conn(:get, "/foo/bar/0.0/baz")
    |> Router.call(nil)
    assert_aar conn, "foo", "bar", "0.0", "baz"
  end

  test "route simple path with invalid aar" do
    conn = conn(:get, "/foo")
    |> Router.call(nil)
    assert_aar conn, nil, nil
  end

  test "route long path with invalid aar" do
    conn = conn(:get, "/foo/bar/0.0/baz/bat")
    |> Router.call(nil)
    assert_aar conn, nil, nil
  end

  defp assert_aar(conn, g, n, r \\ nil, c \\ nil) do
    assert conn.assigns[:asapi_aar] ==
        %Aar{group: g, name: n, revision: r, classifier: c}
  end
end
