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

defmodule Asapi do
  def aar(artifact) do
    String.replace String.trim(artifact <> "@aar"), ~R/@.*$/, "@aar"
  end

  def version(nil) do
    nil
  end

  def version([_, version]) do
    elem Integer.parse(version), 0
  end

  def version(versions) do
    case versions do
      {nil, nil} -> "1+"
      {min_sdk, nil} -> to_string(min_sdk) <> "+"
      {nil, max_sdk} -> "1-" <> to_string(max_sdk)
      {min_sdk, max_sdk} -> to_string(min_sdk) <> "-" <> to_string(max_sdk)
    end
  end
end
