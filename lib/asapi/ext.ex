#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Ext do
  use Supervisor

  @day :timer.hours(24)

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Cachex, name: :lvc, disable_ode: false, default_ttl: @day * 7, ttl_interval: @day}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
