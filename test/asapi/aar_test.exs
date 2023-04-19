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

defmodule Asapi.AarTest do
  use ExUnit.Case
  alias Asapi.Aar
  doctest Aar

  @group "group"
  @name "name"
  @revision "revision"
  @classifier "classifier"

  @aar %Aar{
    group: @group,
    name: @name,
    revision: @revision,
    classifier: @classifier
  }

  test "String.Chars for Aar" do
    assert to_string(%{@aar | revision: nil, classifier: nil}) ==
             "#{@group}:#{@name}:+"

    assert to_string(%{@aar | revision: nil}) ==
             "#{@group}:#{@name}:+:#{@classifier}"

    assert to_string(%{@aar | classifier: nil}) ==
             "#{@group}:#{@name}:#{@revision}"

    assert to_string(@aar) ==
             "#{@group}:#{@name}:#{@revision}:#{@classifier}"

    refute to_string(%{@aar | group: nil})
    refute to_string(%{@aar | name: nil})
  end

  test "sdk_levels! returns 1+ without any sdks" do
    assert Aar.sdk_levels!(File.read!("etc/lv1-0.0-all.aar")) == "1+"
  end

  test "sdk_levels! returns range for different min and max sdks" do
    assert Aar.sdk_levels!(File.read!("etc/lv13-0.0.aar")) == "13-22"
  end

  test "sdk_levels! returns open range for min sdk" do
    assert Aar.sdk_levels!(File.read!("etc/lv21-0.0.aar")) == "21+"
  end

  test "sdk_levels! returns single value for equal min and max sdks" do
    assert Aar.sdk_levels!(File.read!("etc/lv22-0.0.aar")) == "22"
  end

  test "sdk_levels! returns closed range from 1 for single max sdk" do
    assert Aar.sdk_levels!(File.read!("etc/lv23-0.0.aar")) == "1-23"
  end
end
