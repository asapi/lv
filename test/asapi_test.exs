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

defmodule AsapiTest do
  use ExUnit.Case
  use Asapi
  doctest Asapi

  test "using module attributes" do
    assert @unknown == "unknown"
    assert @loading == "…"
  end

  test "badge url with api" do
    assert Asapi.shield("1") ==
             "https://img.shields.io/badge/API-1-informational"

    assert Asapi.shield("2-3") ==
             "https://img.shields.io/badge/API-2--3-informational"

    assert Asapi.shield("4+") ==
             "https://img.shields.io/badge/API-4+-informational"
  end

  test "unknown badge url" do
    assert Asapi.shield(@unknown) ==
             "https://img.shields.io/badge/API-unknown-inactive"
  end

  test "loading badge url" do
    assert Asapi.shield(@loading) ==
             "https://img.shields.io/badge/API-…-inactive"
  end
end
