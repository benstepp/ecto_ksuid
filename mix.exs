defmodule EctoKsuid.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_ksuid,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, ">= 3.0.0"},
      {:ksuid, "0.1.2"},
      {:postgrex, "0.16.4", only: [:dev, :test]},
      {:dialyxir, "1.2.0", only: [:dev], runtime: false},
      {:credo, "1.6.7", only: [:dev]}
    ]
  end
end
