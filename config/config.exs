import Config

config :logger, level: :warn

config :tesla, adapter: Tesla.Adapter.Hackney

config :trot,
  router: Asapi.Router,
  pre_routing: [
    "Elixir.Trot.LiveReload": [env: Mix.env()],
    "Elixir.Plug.Logger": [],
    "Elixir.PlugHeartbeat": [],
    "Elixir.Plug.Static": [at: "/", from: :asapi],
    "Elixir.Asapi.Library": [],
    "Elixir.Asapi.Type": []
  ],
  post_routing: [
    "Elixir.Asapi.Reload": [],
    "Elixir.Asapi.Lv": [],
    "Elixir.Trot.NotFound": []
  ]

import_config "#{Mix.env()}.exs"
