#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Util.InspectTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Asapi.Util.Inspect
  doctest Inspect

  test "init returns options unmodified" do
    assert Inspect.init({1, 2, 3}) == {1, 2, 3}
  end

  test "call inspects and returns conn" do
    conn = %Plug.Conn{port: 4000}
    fun = fn -> assert Inspect.call(conn, {1, 2, 3}) == conn end
    assert capture_io(fun) =~ "#{inspect(conn, pretty: true)}\n"
  end
end
