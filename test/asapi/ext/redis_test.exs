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

defmodule Asapi.Ext.RedisTest do
  use ExUnit.Case
  alias Asapi.Aar
  alias Asapi.Ext.Redis

  @aar %Aar{group: "any.group", name: "lv13", revision: "0.0"}

  setup do
    on_exit fn -> Redix.command! :redix0, ["DEL", "#{@aar}"] end
  end

  defp teardown do
  end

  test "get! returns data if set" do
    Redix.command! :redix0, ["SET", "#{@aar}", "1+"]
    assert Redis.get!(@aar, &(throw &1), 1) == "1+"
  end

  test "get! loads and returns data if unset" do
    assert Redis.get!(@aar, fn _ -> "2+" end, 1) == "2+"
    assert Redis.get!(@aar, &(throw &1), 1) == "2+"
  end

  test "get_and_del! returns and deletes value if set" do
    Redix.command! :redix0, ["SET", "#{@aar}", "3+"]
    assert Redis.get_and_del!(@aar) == "3+"
    assert catch_throw(Redis.get!(@aar, &(throw &1), 1)) == @aar
  end

  test "get_and_del! returns nil if unset" do
    refute Redis.get_and_del!(@aar)
  end
end
