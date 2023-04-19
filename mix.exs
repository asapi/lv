defmodule Asapi.Mixfile do
  use Mix.Project

  def project,
    do: [
      app: :asapi,
      version: "0.6.0",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: aliases()
    ]

  def application,
    do: [
      mod: {Asapi.Ext, []}
    ]

  defp deps,
    do: [
      {:trot, github: "hexedpackets/trot"},
      {:tesla, "~> 1.4.0"},
      {:cachex, "~> 3.4.0"},
      {:hackney, "~> 1.18.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:excoveralls, "~> 0.14.0", only: :test}
    ]

  defp aliases,
    do: [
      asapi: ["run --no-halt"]
    ]
end
