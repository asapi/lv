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

defmodule Asapi.Ext.Version do
  alias Asapi.Ext.Version

  defstruct major: 0, minor: 0, rev: 0, s: nil

  def parse!(nil), do: %Version{}
  def parse!(%Version{} = version), do: version

  def parse!(v) do
    String.split(v, ".")
    |> Enum.map(&elem(Integer.parse(&1), 0))
    |> case do
      [maj, min, rev | _] -> %Version{major: maj, minor: min, rev: rev, s: v}
      [maj, min] -> %Version{major: maj, minor: min, s: v}
      [maj] -> %Version{major: maj, s: v}
    end
  end

  def matching?(pattern, v) do
    String.starts_with?(v.s, pattern)
  end

  def v1 <= v2 do
    cond do
      v1.major != v2.major -> v1.major < v2.major
      v1.minor != v2.minor -> v1.minor < v2.minor
      v1.rev != v2.rev -> v1.rev < v2.rev
      true -> true
    end
  end
end
