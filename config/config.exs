use Mix.Config

config :logger, level: :info

config :trot, :router, Asapi.Router
config :trot, :pre_routing, [
  "Elixir.Trot.LiveReload": [env: Mix.env],
  "Elixir.Plug.Logger": [],
  "Elixir.Asapi.Library": []
]

case System.get_env "PORT" do
  nil -> nil
  port -> config :trot, :port, port
end
