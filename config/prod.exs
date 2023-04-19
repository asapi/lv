import Config
import System

config :trot,
  port: get_env("PORT"),
  pre_routing: [
    "Elixir.Plug.SSL": [rewrite_on: [:x_forwarded_proto]],
    "Elixir.PlugHeartbeat": [],
    "Elixir.Plug.Static": [at: "/", from: :asapi],
    "Elixir.Asapi.Library": [],
    "Elixir.Asapi.Type": []
  ]
