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
  @loading "…"
  @unknown "unknown"

  def shield(status) when status in [@loading, @unknown] do
    shield(status, "inactive")
  end

  def shield(status) do
    shield(status, "informational")
  end

  defp shield(status, color) do
    "https://img.shields.io/badge/API-#{encode status}-#{color}"
  end

  defp encode(part) do
    String.replace(part, "-", "--")
  end

  defmacro __using__(_) do
    quote do
      import Asapi
      @loading unquote(@loading)
      @unknown unquote(@unknown)
    end
  end
end
