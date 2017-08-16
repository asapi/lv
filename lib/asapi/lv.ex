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

defmodule Asapi.Lv do
  alias Asapi.Aar
  require Logger
  use Asapi

  def api_lv(%Aar{group: nil}) do
    @unknown
  end

  def api_lv(%Aar{name: nil}) do
    @unknown
  end

  def api_lv(%Aar{} = aar) do
    try do
      case Aar.sdk_levels! aar do
        nil -> @unknown
        lv -> lv
      end
    rescue error ->
      Logger.warn Exception.message error
      @unknown
    end
  end
end
