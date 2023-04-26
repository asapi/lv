import Config

config :logger, level: :warn

config :tesla, adapter: Tesla.Adapter.Hackney

import_config "#{Mix.env()}.exs"
