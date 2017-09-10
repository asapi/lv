defmodule Asapi.Util.InspectTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Asapi.Util.Inspect
  doctest Inspect

  test "init returns options unmodified" do
    opts = {1, 2, 3}
    assert Inspect.init(opts) == opts
  end

  test "call inspects and returns conn" do
    conn = %Plug.Conn{port: 4000}
    fun = fn -> assert Inspect.call(conn, {1, 2, 3}) == conn end
    assert capture_io(fun) ==
        "#{inspect(conn, pretty: true)}\n"
  end
end
