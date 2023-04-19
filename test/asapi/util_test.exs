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

defmodule Asapi.UtilTest do
  use ExUnit.Case
  alias Asapi.Util
  doctest Util

  test "build_url returns path for non query" do
    path = "/abc"
    conn = %Plug.Conn{}
    assert Util.build_url(conn, path) == path
  end

  test "build_url returns path for consumed query" do
    path = "/abc"
    query = "a=b&c=d&e=f"
    conn = %Plug.Conn{query_string: query}
    assert Util.build_url(conn, path, ["a", "c", "e"]) == path
  end

  test "build_url returns path with query" do
    path = "/abc"
    query = "a=b&c=d&e=f"
    conn = %Plug.Conn{query_string: query}

    assert Util.build_url(conn, path) ==
             "#{path}?#{query}"
  end

  test "build_url returns path with non consumed query" do
    path = "/abc"
    query = "a=b&c=d&e=f"
    conn = %Plug.Conn{query_string: query}

    assert Util.build_url(conn, path, ["c"]) ==
             "#{path}?a=b&e=f"
  end

  test "redirect_to redirects url" do
    url = "https://www.example.com/path"

    assert Util.redirect_to(url) ==
             {:redirect, url}
  end

  test "send_text is ok and plain text" do
    text = "some text to send"

    assert Util.send_text(text) ==
             {:ok, text, ["content-type": "text/plain"]}
  end
end
