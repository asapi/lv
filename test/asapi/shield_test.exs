#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.ShieldTest do
  use ExUnit.Case
  use Asapi.Shield

  alias Asapi.Shield

  doctest Shield

  test "using module attributes" do
    assert @unknown == "unknown"
    assert @loading == "…"
  end

  test "badge url with api" do
    assert Shield.shield("1") ==
             "https://img.shields.io/badge/API-1-informational"

    assert Shield.shield("2-3") ==
             "https://img.shields.io/badge/API-2--3-informational"

    assert Shield.shield("4+") ==
             "https://img.shields.io/badge/API-4+-informational"
  end

  test "unknown badge url" do
    assert Shield.shield(@unknown) ==
             "https://img.shields.io/badge/API-unknown-inactive"
  end

  test "loading badge url" do
    assert Shield.shield(@loading) ==
             "https://img.shields.io/badge/API-…-inactive"
  end
end
