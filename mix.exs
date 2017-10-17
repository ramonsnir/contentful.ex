defmodule Contentful.Mixfile do
  use Mix.Project

  def project do
    [app: :contentful,
     version: "0.1.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     aliases: aliases(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       travis: :test,
       vcr: :test,
       "vcr.delete": :test,
       "vcr.check": :test,
       "vcr.show": :test,
       coveralls: :test,
     ],
    ]
  end

  defp package do
    [# These are the default files included in the package
     name: :contentful,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Contentful GmbH (David Litvak Bruno)"],
     licenses: ["MIT"],
     links: %{
       "GitHub" => "https://github.com/contentful-labs/contentful.ex"
     }
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [
      :logger,
      :httpoison,
    ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.9", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.7", only: :test},
    ]
  end

  defp description do
    """
    Contentful Content Delivery API SDK
    """
  end

  defp aliases do
    [
      travis: [
        "test --raise",
        "credo --strict --all",
      ],
    ]
  end
end
