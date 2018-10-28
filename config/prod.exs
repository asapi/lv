use Mix.Config
import System

config :redix,
    url: get_env("REDIS_URL"),
    count: get_env("REDIS_CONN_COUNT")

config :trot, :port, get_env("PORT")
