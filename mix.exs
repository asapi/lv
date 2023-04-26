defmodule Asapi.Mixfile do
  use Mix.Project

  def application do
    [mod: {Asapi, []}]
  end

  def project do
    [
      app: :asapi,
      version: "0.0.0",
      elixir: "~> 1.14",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: [
        asapi: ["run --no-halt"],
        priv: ["cmd --cd priv npm run build"]
      ],
      deps: [
        {:tesla, "~> 1.4"},
        {:cachex, "~> 3.4"},
        {:hackney, "~> 1.18"},
        {:plug_cowboy, "~> 2.6"},
        {:mock, "~> 0.3", only: :test},
        {:excoveralls, "~> 0.14", only: :test}
      ]
    ]
  end
end
