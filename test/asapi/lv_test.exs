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

defmodule Asapi.LvTest do
  use ExUnit.Case
  use Plug.Test
  use Asapi
  import Mock
  import ExUnit.CaptureLog
  alias Asapi.Lv
  alias Asapi.Aar
  alias Asapi.Ext.Data
  doctest Lv

  @aar %Aar{group: "any.group", name: "lv13", revision: "0.0"}


  test "init returns options unmodified" do
    assert Lv.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call returns conn with state not :unset" do
    conn = conn(:get, "/foo")
    |> Map.put(:state, :set)
    |> put_private(:test, :value)
    assert Lv.call(conn, nil) == conn
  end

  test "call returns conn with aar and ext unset" do
    conn = conn(:get, "/foo")
    |> put_private(:test, :value)
    assert Lv.call(conn, nil) == conn
  end


  test "call renders html with default host and unknown" do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with default host",
        Data, [get!: fn _ -> "1+" end] do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    assert called Data.get! @aar
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ to_string @aar
    assert conn.resp_body =~ "1+"
  end

  test "call renders html with default https host and unknown" do
    conn = conn(:get, "/foo")
    |> Map.put(:port, 443)
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with default https host",
        Data, [get!: fn _ -> "2+" end] do
    conn = conn(:get, "/foo")
    |> Map.put(:port, 443)
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    assert called Data.get! @aar
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ to_string @aar
    assert conn.resp_body =~ "2+"
  end

  test "call renders html with default host and port and unknown" do
    conn = conn(:get, "/foo")
    |> Map.put(:port, 123)
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    assert conn.resp_body =~ "#{conn.host}:123"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with host and port",
        Data, [get!: fn _ -> "3+" end] do
    conn = conn(:get, "/foo")
    |> Map.put(:port, 123)
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :html)
    |> Lv.call(nil)
    assert called Data.get! @aar
    assert conn.resp_body =~ "#{conn.host}:123"
    assert conn.resp_body =~ to_string @aar
    assert conn.resp_body =~ "3+"
  end


  test "call redirects png shields with unknown api level" do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :png)
    |> Lv.call(nil)
    assert {"location", "#{shield @unknown}.png"} in conn.resp_headers
  end

  test_with_mock "call redirects png shields with api level",
        Data, [get!: fn _ -> "11+" end] do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :png)
    |> Lv.call(nil)
    assert called Data.get! @aar
    assert {"location", "#{shield "11+"}.png"} in conn.resp_headers
  end

  test "call redirects svg shields with unknown api level" do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :svg)
    |> Lv.call(nil)
    assert {"location", "#{shield @unknown}.svg"} in conn.resp_headers
  end

  test_with_mock "call redirects svg shields with api level",
        Data, [get!: fn _ -> "12+" end] do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :svg)
    |> Lv.call(nil)
    assert called Data.get! @aar
    assert {"location", "#{shield "12+"}.svg"} in conn.resp_headers
  end


  test "call returns txt to with unknown api level" do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, %{@aar | group: nil})
    |> assign(:asapi_ext, :txt)
    |> Lv.call(nil)
    assert conn.resp_body == @unknown
  end

  test_with_mock "call returns txt to with api level",
        Data, [get!: fn _ -> "13+" end] do
    conn = conn(:get, "/foo")
    |> assign(:asapi_aar, @aar)
    |> assign(:asapi_ext, :txt)
    |> Lv.call(nil)
    assert called Data.get! @aar
    assert conn.resp_body == "13+"
  end

  test_with_mock "call processes unknown api level on error",
        Data, [get!: fn _ -> raise "error" end] do
    fun = fn ->
      conn = conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :txt)
      |> Lv.call(nil)
      assert called Data.get! @aar
      assert conn.resp_body == @unknown
    end
    assert capture_log(fun) =~ "error"
  end
end
