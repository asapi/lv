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
                ".aar" -> File.read!("etc/#{Path.basename(env.url)}")
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
