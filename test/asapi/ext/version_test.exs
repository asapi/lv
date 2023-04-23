#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

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
