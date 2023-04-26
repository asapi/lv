import Config

try do
  System.get_env("PORT")
  |> String.to_integer()
rescue
  _ -> nil
else
  port -> config :asapi, port: port
end
