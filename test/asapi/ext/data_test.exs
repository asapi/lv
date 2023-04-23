#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Ext.DataTest do
  use ExUnit.Case
  alias Asapi.Aar
  alias Asapi.Ext.Data

  @aar0 %Aar{group: "any.group", name: "lv13", revision: "0.1"}
  @aar1 %{@aar0 | revision: "0.0"}
  @aar2 %{@aar0 | revision: nil}

  setup do
    Tesla.Mock.mock_global(fn env ->
      if String.contains?(env.url, "no/group") do
        %{env | status: 404}
      else
        %{
          env
          | status: 200,
            body:
              case Path.extname(env.url) do
                ".aar" -> File.read!("test/aar/#{Path.basename(env.url)}")
                ".xml" -> "<version>0.0</version>"
              end
        }
      end
    end)

    on_exit(fn ->
      Cachex.del(:lvc, @aar0)
      Cachex.del(:lvc, @aar1)
      Cachex.del(:lvc, {@aar1})
      Cachex.del(:lvc, @aar2)
      Cachex.del(:lvc, {@aar2})
    end)
  end

  test "get! sdk levels from cache" do
    cache_set!(@aar1, "11+")
    assert Data.get!(@aar1) == "11+"
  end

  test "get! sdk levels from remote" do
    assert Data.get!(@aar1) == "13-22"
    assert cache_get!(@aar1) == "13-22"
  end

  test "get! resolved sdk levels from cache" do
    cache_set!(@aar1, "21+")
    cache_set!(@aar2, @aar1.revision)
    assert Data.get!(@aar2) == "21+"
  end

  test "get! resolved sdk levels from remote" do
    assert Data.get!(@aar2) == "13-22"
    assert cache_get!(@aar1) == "13-22"
    assert cache_get!(@aar2) == @aar1.revision
  end

  test "clear! cache values" do
    cache_set!(@aar1, "31+")
    cache_set!(@aar2, @aar1.revision)
    refute Data.clear!(@aar1)
    refute cache_get!(@aar1)
    assert cache_get!(@aar2) == @aar1.revision
  end

  test "clear! resolved cache values" do
    cache_set!(@aar1, "32+")
    cache_set!(@aar2, @aar1.revision)
    refute Data.clear!(@aar2)
    refute cache_get!(@aar1)
    refute cache_get!(@aar2)
  end

  defp cache_set!(key, value) do
    Cachex.set!(:lvc, key, value)
  end

  defp cache_get!(key) do
    Cachex.get!(:lvc, key)
  end
end
