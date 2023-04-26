#  Copyright 2023 Christian Schmitz
#  SPDX-License-Identifier: AGPL-3.0-or-later

defmodule Asapi do
  use Application

  @impl true
  def start(_type, _args) do
    cowboy_options = [
      compress: true,
      port: Application.get_env(:asapi, :port, 4000)
    ]

    children = [
      Asapi.Ext,
      {Plug.Cowboy, scheme: :http, plug: Asapi.Router, options: cowboy_options}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
