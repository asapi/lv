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

defmodule Asapi.Ext.RepoTest do
  use ExUnit.Case
  alias Asapi.Aar
  alias Asapi.Ext.Repo

  @aar %Aar{group: "any.group", name: "lv13", revision: "0.0"}

  setup do
    Tesla.Mock.mock fn env ->
      if String.contains? env.url, "no/group" do
        %{env | status: 404}
      else
        %{env | status: 200, body: case Path.extname env.url do
          ".aar" -> File.read! "etc/#{Path.basename env.url}"
          ".xml" -> "<version>0.1</version><version>v0.0</version><version>0.0</version>"
        end}
      end
    end
    :ok
  end


  test "resolve! returns highest version" do
    assert Repo.resolve!(@aar) == "0.1"
  end

  test "resolve! errors on unknown aar" do
    assert_raise BadMapError, fn ->
      Repo.resolve! %{@aar | group: "no.group"}
    end
  end

  test "resolve? required for dynamic versions" do
    assert Repo.resolve? %{@aar | revision: ""}
    assert Repo.resolve? %{@aar | revision: nil}
    assert Repo.resolve? %{@aar | revision: "1+"}
    assert Repo.resolve? %{@aar | revision: "1.+"}
    assert Repo.resolve? %{@aar | revision: "1.2+"}
    assert Repo.resolve? %{@aar | revision: "1.2.+"}
    assert Repo.resolve? %{@aar | revision: "latest.release"}
    assert Repo.resolve? %{@aar | revision: "latest.milestone"}
    assert Repo.resolve? %{@aar | revision: "latest.integration"}
    refute Repo.resolve? %{@aar | revision: "1.2.3"}
    refute Repo.resolve? %{@aar | revision: "1.2"}
    refute Repo.resolve? %{@aar | revision: "1"}
  end

  test "load! reads minimal and maximal sdk levels from manifest" do
    assert Repo.load!(@aar) == "13-22"
  end

  test "load! considers artifact classifier" do
    assert Repo.load!(%{@aar | name: "lv1", classifier: "all"}) == "1+"
  end

  test "load! errors on unknown aar" do
    assert_raise MatchError, fn ->
      Repo.load! %{@aar | group: "no.group"}
    end
  end
end
