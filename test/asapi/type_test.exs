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

defmodule Asapi.TypeTest do
  use ExUnit.Case
  use Plug.Test
  alias Asapi.Type
  doctest Type

  test "init returns options unmodified" do
    assert Type.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call returns conn with state not :unset" do
    conn = conn(:get, "/foo")
    |> Map.put(:state, :set)
    |> put_private(:test, :value)
    assert Type.call(conn, nil) == conn
  end

  test "call sets html extension as default" do
    conn = conn(:get, "/foo")
    |> Type.call(nil)
    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == ["foo"]
  end

  test "call sets html extension as no extension" do
    conn = conn(:get, "/foo@")
    |> Type.call(nil)
    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == ["foo"]
  end

  test "call sets extension" do
    conn = conn(:get, "/foo@svg")
    |> Type.call(nil)
    assert conn.assigns[:asapi_ext] == :svg
    assert conn.path_info == ["foo"]
  end

  test "call sets first extension only" do
    conn = conn(:get, "/foo@txt@svg")
    |> Type.call(nil)
    assert conn.assigns[:asapi_ext] == :txt
    assert conn.path_info == ["foo"]
  end

  test "call removes empty path info" do
    conn = conn(:get, "/@html")
    |> Type.call(nil)
    assert conn.assigns[:asapi_ext] == :html
    assert conn.path_info == []
  end
end
