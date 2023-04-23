#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

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
