#  Copyright 2017 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi.Ext do
  @day :timer.hours(24)

  def start(_type, _args) do
    Cachex.start_link(:lvc,
      disable_ode: false,
      default_ttl: @day * 7,
      ttl_interval: @day
    )
  end
end
