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

defmodule Asapi.Redirect do
  import Plug.Conn, only: [fetch_query_params: 1]
  import Plug.Conn.Query, only: [encode: 1]

  def build_url(%Plug.Conn{} = conn, path, consumed \\ []) do
    conn
    |> fetch_query_params
    |> Map.get(:query_params)
    |> Map.drop(consumed)
    |> encode
    |> case do
      "" -> path
      query -> "#{path}?#{query}"
    end
  end
end
