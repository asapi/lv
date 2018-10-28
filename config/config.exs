use Mix.Config

config :logger, level: :warn

config :trot,
    router: Asapi.Router,
    pre_routing: [
      "Elixir.Trot.LiveReload": [env: Mix.env],
      "Elixir.Plug.Logger": [],
      "Elixir.Asapi.Library": [],
      "Elixir.PlugHeartbeat": [],
      "Elixir.Plug.Static": [at: "/", from: :asapi],
      "Elixir.Asapi.Type": []
    ],
    post_routing: [
      "Elixir.Asapi.Reload": [],
      "Elixir.Asapi.Lv": [],
      "Elixir.Trot.NotFound": []
    ]

import_config "#{Mix.env}.exs"
