defmodule Lv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :asapi,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls.json": :test]
    ]
  end

  def application do
    [
      applications: [:cachex, :redix, :tesla, :trot],
      mod: {Asapi.Ext, []}
    ]
  end

  defp deps do
    [
      {:trot, github: "hexedpackets/trot"},
      {:tesla, "~> 0.7.1"},
      {:redix, ">= 0.0.0"},
      {:cachex, "~> 2.1"},
      {:mock, "~> 0.2", only: :test},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end
end
