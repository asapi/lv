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

defmodule Asapi.Aar do
  alias Asapi.Aar
  require Logger

  @enforce_keys [:group, :name]
  defstruct [:group, :name, :version, :classifier]

  def resolve(%Aar{} = aar) do
    aar
  end

  def artifact(%Aar{group: nil}) do
    nil
  end

  def artifact(%Aar{name: nil}) do
    nil
  end

  def artifact(%Aar{version: nil, classifier: nil} = aar) do
    "#{aar.group}:#{aar.name}:+"
  end

  def artifact(%Aar{version: nil} = aar) do
    "#{aar.group}:#{aar.name}:+:#{aar.classifier}"
  end

  def artifact(%Aar{classifier: nil} = aar) do
    "#{aar.group}:#{aar.name}:#{aar.version}"
  end

  def artifact(%Aar{} = aar) do
    "#{aar.group}:#{aar.name}:#{aar.version}:#{aar.classifier}"
  end
end
