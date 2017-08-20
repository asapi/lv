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
        "https://img.shields.io/badge/API-1-blue"
    assert Asapi.shield("2-3") ==
        "https://img.shields.io/badge/API-2--3-blue"
    assert Asapi.shield("4+") ==
        "https://img.shields.io/badge/API-4%2B-blue"
  end

  test "unknown badge url" do
    assert Asapi.shield(@unknown) ==
        "https://img.shields.io/badge/API-unknown-lightgrey"
  end

  test "loading badge url" do
    assert Asapi.shield(@loading) ==
        "https://img.shields.io/badge/API-%E2%80%A6-lightgrey"
  end
end
