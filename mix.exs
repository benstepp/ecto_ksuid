defmodule EctoKsuid.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_ksuid,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: "https://github.com/benstepp/ecto_ksuid",
      homepage_url: "https://github.com/benstepp/ecto_ksuid",
      deps: deps(),
      docs: docs()
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
      {:credo, "1.6.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "1.2.0", only: [:dev], runtime: false},
      {:ex_doc, "0.28.5", only: [:dev], runtime: false}
    ]
  end

  defp docs() do
    [
      main: "readme",
      api_reference: false,
      authors: ["Benjamin Stepp"],
      extras: extras(),
      extra_section: "guides",
      groups_for_extras: [
        Introduction: ["README.md"],
        Guides: [
          "guides/using_ksuid_as_default.md",
          "guides/configuring_prefix.md"
        ]
      ]
    ]
  end

  defp extras() do
    [
      "README.md",
      "guides/using_ksuid_as_default.md",
      "guides/configuring_prefix.md"
    ]
  end
end
