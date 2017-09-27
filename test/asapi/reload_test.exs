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

defmodule Asapi.ReloadTest do
  use ExUnit.Case
  use Plug.Test
  import Mock
  import ExUnit.CaptureLog
  alias Asapi.Aar
  alias Asapi.Reload
  alias Asapi.Ext.Data
  doctest Reload

  @aar %Aar{group: "any.group", name: "lv13", revision: "0.1"}

  test "init returns options unmodified" do
    assert Reload.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call returns conn without reload param" do
    conn = conn(:get, "/foo")
    |> put_private(:test, :value)
    |> fetch_query_params
    assert Reload.call(conn, nil) == conn
  end

  test_with_mock "call ignores unset aar and redirects",
        Data, [clear!: fn _ -> raise "error" end] do
    conn = conn(:get, "/foo?reload")
    |> put_private(:test, :value)
    |> fetch_query_params
    assert_redirect(conn, "/foo")
    refute called Data.clear! @aar
  end

  test_with_mock "call ignores aar with invalid group and redirects",
        Data, [clear!: fn _ -> nil end] do
    conn = conn(:get, "/foo?reload")
    |> put_private(:test, :value)
    |> fetch_query_params
    |> assign(:asapi_aar, %{@aar | group: nil})
    assert_redirect(conn, "/foo")
    refute called Data.clear! @aar
  end

  test_with_mock "call ignores aar with invalid name and redirects",
        Data, [clear!: fn _ -> nil end] do
    conn = conn(:get, "/foo?reload")
    |> put_private(:test, :value)
    |> fetch_query_params
    |> assign(:asapi_aar, %{@aar | name: nil})
    assert_redirect(conn, "/foo")
    refute called Data.clear! @aar
  end

  test_with_mock "call clears cached values and redirects",
        Data, [clear!: fn _ -> nil end] do
    conn = conn(:get, "/foo?reload")
    |> put_private(:test, :value)
    |> fetch_query_params
    |> assign(:asapi_aar, @aar)
    assert_redirect(conn, "/foo")
    assert called Data.clear! @aar
  end

  test_with_mock "call logs message on clear! error and redirects",
        Data, [clear!: fn _ -> raise "error" end] do
    conn = conn(:get, "/foo?reload")
    |> put_private(:test, :value)
    |> fetch_query_params
    |> assign(:asapi_aar, @aar)
    assert capture_log(fn -> assert_redirect(conn, "/foo") end) =~ "error"
    assert called Data.clear! @aar
  end


  defp assert_redirect(conn, path) do
    assert {"location", path} in Reload.call(conn, nil).resp_headers
  end
end
