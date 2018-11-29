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

defmodule Asapi.Ext do
  use Application
  use Supervisor

  def start(_type, _args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    redis_url = Application.get_env :redix, :url
    {redis_count, _} = Integer.parse Application.get_env :redix, :count, "5"
    [
      worker(Cachex, [ :lvc, [
        ode: true,
        default_ttl: :timer.hours(2),
        ttl_interval: -1
      ] ]),
      supervisor(Asapi.Ext.Redis, [ {redis_url, redis_count} ])
    ]
    |> supervise(strategy: :one_for_one)
  end
end
