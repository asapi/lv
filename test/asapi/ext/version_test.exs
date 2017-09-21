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

defmodule Asapi.Ext.VersionTest do
  use ExUnit.Case
  alias Asapi.Ext.Version
  doctest Version

  test "defaults set to 0 or nil" do
    assert %Version{} == %Version{major: 0, minor: 0, rev: 0, s: nil}
  end

  test "parse! nil to default" do
    assert Version.parse!(nil) == %Version{major: 0, minor: 0, rev: 0, s: nil}
  end

  test "parse! version to version" do
    v = %Version{major: 1, minor: 2, rev: 3, s: "1.2.3"}
    assert Version.parse!(v) == v
  end

  test "parse! x[.x[.x[.*]]] to version" do
    assert Version.parse!("1") ==
        %Version{major: 1, s: "1"}
    assert Version.parse!("1.2") ==
        %Version{major: 1, minor: 2, s: "1.2"}
    assert Version.parse!("1.2.3") ==
        %Version{major: 1, minor: 2, rev: 3, s: "1.2.3"}
    assert Version.parse!("1.2.3.4") ==
        %Version{major: 1, minor: 2, rev: 3, s: "1.2.3.4"}
  end

  test "parse! fail on non x[.x[.x[.*]]]" do
    assert_raise ArgumentError, fn -> Version.parse!("") end
    assert_raise ArgumentError, fn -> Version.parse!("x") end
    assert_raise ArgumentError, fn -> Version.parse!("x.x") end
    assert_raise ArgumentError, fn -> Version.parse!("1.x") end
    assert_raise ArgumentError, fn -> Version.parse!("x.x.x") end
    assert_raise ArgumentError, fn -> Version.parse!("1.2.x") end
    assert_raise ArgumentError, fn -> Version.parse!("x.x.x.x") end
    assert_raise ArgumentError, fn -> Version.parse!("1.2.3.x") end
  end

  test "matching? matches the version prefix" do
    v = %Version{s: "1.2.34"}
    assert Version.matching?("1", v)
    assert Version.matching?("1.", v)
    assert Version.matching?("1.2", v)
    assert Version.matching?("1.2.", v)
    assert Version.matching?("1.2.3", v)
    assert Version.matching?("1.2.34", v)
    assert not Version.matching?("1.2.345", v)
    assert not Version.matching?("1.2.35", v)
    assert not Version.matching?("1.2.4", v)
    assert not Version.matching?("1.3", v)
    assert not Version.matching?("2", v)
  end

  test "ordering with <= of versions" do
    v = %Version{major: 1, minor: 2, rev: 3}
    assert v <= %Version{major: 1, minor: 2, rev: 4}
    assert v <= %Version{major: 1, minor: 3}
    assert v <= %Version{major: 2}
  end
end
