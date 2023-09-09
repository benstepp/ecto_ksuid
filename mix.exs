defmodule EctoKsuid.MixProject do
  use Mix.Project

  @version "0.3.0"
  @source_url "https://github.com/benstepp/ecto_ksuid"

  def project do
    [
      app: :ecto_ksuid,
      description: description(),
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: @source_url,
      homepage_url: @source_url,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.github": :test,
        "coveralls.html": :test
      ],
      package: package(),
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
      {:ecto_sql, ">= 3.10.0"},
      {:ksuid, "0.1.2"},
      {:postgrex, "0.16.4", only: [:dev, :test]},
      {:credo, "1.6.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "1.3.0", only: [:dev], runtime: false},
      {:ex_doc, "0.28.5", only: [:dev], runtime: false},
      {:excoveralls, "0.14.6", only: [:test]}
    ]
  end

  defp description() do
    """
    Ecto.Type that allows using ksuids with developer friendly prefixes. (ie.
    "user_2EgT2R97RRNXWXdA3Ov6znVLDCd").
    """
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

  defp package() do
    [
      name: :ecto_ksuid,
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url
      }
    ]
  end
end
