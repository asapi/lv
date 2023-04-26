#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.LvTest do
  use ExUnit.Case
  use Plug.Test
  use Asapi.Shield

  alias Asapi.Lv
  alias Asapi.Aar
  alias Asapi.Ext.Data

  doctest Lv

  import ExUnit.CaptureLog
  import Mock

  @aar %Aar{group: "any.group", name: "lv13", revision: "0.0"}

  test "init returns options unmodified" do
    assert Lv.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call returns conn with state not :unset" do
    conn =
      conn(:get, "/foo")
      |> Map.put(:state, :set)
      |> put_private(:test, :value)

    assert Lv.call(conn, nil) == conn
  end

  test "call returns conn with aar and ext unset" do
    conn =
      conn(:get, "/foo")
      |> put_private(:test, :value)

    assert Lv.call(conn, nil) == conn
  end

  test "call renders html with default host and unknown" do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, %{@aar | name: nil})
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with default host", Data, get!: fn _ -> "1+" end do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ to_string(@aar)
    assert conn.resp_body =~ "1+"
  end

  test "call renders html with default https host and unknown" do
    conn =
      conn(:get, "/foo")
      |> Map.put(:port, 443)
      |> assign(:asapi_aar, %{@aar | group: nil})
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with default https host", Data, get!: fn _ -> "2+" end do
    conn =
      conn(:get, "/foo")
      |> Map.put(:port, 443)
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    refute conn.resp_body =~ "#{conn.host}:"
    assert conn.resp_body =~ "#{conn.host}"
    assert conn.resp_body =~ to_string(@aar)
    assert conn.resp_body =~ "2+"
  end

  test_with_mock "call renders html with default host and port and unknown", Data,
    get!: fn _ -> nil end do
    conn =
      conn(:get, "/foo")
      |> Map.put(:port, 123)
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    assert conn.resp_body =~ "#{conn.host}:123"
    assert conn.resp_body =~ @unknown
  end

  test_with_mock "call renders html with host and port", Data, get!: fn _ -> "3+" end do
    conn =
      conn(:get, "/foo")
      |> Map.put(:port, 123)
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :html)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    assert conn.resp_body =~ "#{conn.host}:123"
    assert conn.resp_body =~ to_string(@aar)
    assert conn.resp_body =~ "3+"
  end

  test "call redirects png shields with unknown api level" do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, %{@aar | group: nil})
      |> assign(:asapi_ext, :png)
      |> Lv.call(nil)

    assert {"location", "#{shield(@unknown)}.png"} in conn.resp_headers
  end

  test_with_mock "call redirects png shields with api level", Data, get!: fn _ -> "11+" end do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :png)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    assert {"location", "#{shield("11+")}.png"} in conn.resp_headers
  end

  test "call redirects svg shields with unknown api level" do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, %{@aar | group: nil})
      |> assign(:asapi_ext, :svg)
      |> Lv.call(nil)

    assert {"location", "#{shield(@unknown)}.svg"} in conn.resp_headers
  end

  test_with_mock "call redirects svg shields with api level", Data, get!: fn _ -> "12+" end do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :svg)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    assert {"location", "#{shield("12+")}.svg"} in conn.resp_headers
  end

  test "call returns json to with unknown api level" do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, %{@aar | group: nil})
      |> assign(:asapi_ext, :json)
      |> Lv.call(nil)

    assert conn.resp_body == shield(@unknown, json: true)
  end

  test_with_mock "call returns json to with api level", Data, get!: fn _ -> "13+" end do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :json)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    assert conn.resp_body == shield("13+", json: true)
  end

  test "call returns txt to with unknown api level" do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, %{@aar | group: nil})
      |> assign(:asapi_ext, :txt)
      |> Lv.call(nil)

    assert conn.resp_body == @unknown
  end

  test_with_mock "call returns txt to with api level", Data, get!: fn _ -> "13+" end do
    conn =
      conn(:get, "/foo")
      |> assign(:asapi_aar, @aar)
      |> assign(:asapi_ext, :txt)
      |> Lv.call(nil)

    assert called(Data.get!(@aar))
    assert conn.resp_body == "13+"
  end

  test_with_mock "call processes unknown api level on error", Data,
    get!: fn _ -> raise "error" end do
    fun = fn ->
      conn =
        conn(:get, "/foo")
        |> assign(:asapi_aar, @aar)
        |> assign(:asapi_ext, :txt)
        |> Lv.call(nil)

      assert called(Data.get!(@aar))
      assert conn.resp_body == @unknown
    end

    assert capture_log(fun) =~ "error"
  end
end
