defmodule SilentAuction.MixProject do
  use Mix.Project

  def project do
    [
      app: :silent_auction,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SilentAuction.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tz, "~> 0.28.1"},
      {:bandit, "~> 1.5.7"},
      {:jason, "~> 1.4.4"},
      {:absinthe, "~> 1.7.8"},
      {:absinthe_plug, "~> 1.5.8"},
      {:ecto_sql, "~> 3.12.1"},
      {:postgrex, "~> 0.19.2"}
    ]
  end

  defp elixirc_paths(:test) do
    elixirc_paths(:dev) ++ ["test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end

  defp aliases do
    [
      test: [
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ]
    ]
  end
end
