defmodule Asapi.Mixfile do
  use Mix.Project

  def project, do: [
    app: :asapi,
    version: "0.2.0",
    elixir: "~> 1.4",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps(),
    test_coverage: [ tool: ExCoveralls ],
    preferred_cli_env: [ "coveralls.json": :test ],
    aliases: aliases()
  ]

  def application, do: [
    mod: { Asapi.Ext, [] }
  ]

  defp deps, do: [
    { :trot, github: "hexedpackets/trot" },
    { :tesla, "~> 0.7.1" },
    { :redix, ">= 0.0.0" },
    { :cachex, "~> 2.1" },
    { :mock, "~> 0.2", only: :test },
    { :excoveralls, "~> 0.7", only: :test }
  ]

  defp aliases, do: [
    "run.all": [ "run --no-halt" ]
  ]
end
