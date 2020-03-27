defmodule Asapi.Mixfile do
  use Mix.Project

  def project, do: [
    app: :asapi,
    version: "0.3.1",
    elixir: "~> 1.6",
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
    { :tesla, "~> 1.3.0" },
    { :redix, "~> 0.10" },
    { :cachex, "~> 3.2.0" },
    { :hackney, "~> 1.15.0" },
    { :mock, "~> 0.3", only: :test },
    { :excoveralls, "~> 0.12", only: :test }
  ]

  defp aliases, do: [
    asapi: [ "run --no-halt" ]
  ]
end
