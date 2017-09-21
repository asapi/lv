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
