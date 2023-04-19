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
