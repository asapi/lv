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

defmodule Asapi.Ext.Redis do
  alias Asapi.Aar
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init({nil, count}), do: setup(count)
  def init({url, count}), do: setup(count, [ url ])

  defp setup(count, args \\ []) do
    ids = 0..count-1
    for i <- ids do
      worker(Redix, args ++ [[ name: :"redix#{i}" ]], id: {Redix, i})
    end ++ [
      worker(Agent, [ fn -> reset ids end, [ name: :nid ] ])
    ]
    |> supervise(strategy: :one_for_one)
  end


  def get!(%Aar{} = aar, rcb, dtl) when is_function(rcb, 1) do
    aar
    |> to_string
    |> get!
    |> case do
        nil -> set! aar, rcb.(aar), dtl
        value -> value
    end
  end

  defp get!(key) when is_binary(key) do
    Redix.command! conn(), ["GET", key]
  end

  defp set!(%Aar{} = aar, value, dtl) do
    if value do
      Redix.command! conn(), [
          "SET", to_string(aar), to_string(value),
          "EX", to_string(dtl*86400)
      ]
    end
    value
  end


  def get_and_del!(%Aar{} = aar) do
    key = to_string aar
    Redix.pipeline!(conn(), [
        [ "MULTI" ],
        [ "GET", key ],
        [ "DEL", key ],
        [ "EXEC" ]
    ])
    |> List.last
    |> List.first
  end


  defp get_and_incr({ids, id}) do
    nid = id + 1
    if nid in ids do
      { id, {ids, nid} }
    else
      { id, reset ids }
    end
  end

  defp conn, do: :"redix#{Agent.get_and_update :nid, &get_and_incr/1}"
  defp reset(ids), do: {ids, Enum.min ids}
end
