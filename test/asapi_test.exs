#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

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
