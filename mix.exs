defmodule Simple.Mixfile do
  use Mix.Project

  def project do
    [
      app: :simple,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Simple.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bamboo, "~> 0.7"}, # emails
      {:bamboo_postmark, "~> 0.4.1"}, # postmark adapter for emails
      {:bootleg, "~> 0.6"}, # deployment
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:cloudex, "~> 1.0"},
      {:credo, "~> 0.8", only: [:dev, :test]}, # Code style suggestions
      {:corsica, "~> 1.1.0"},
      {:distillery, "~> 1.5", runtime: false},
      {:ex_machina, "~> 2.1", only: :test}, # test factories
      {:ex_rated, "~> 1.2"},
      {:guardian, "~> 1.0"}, # Authentication (JWT)
      {:jsonapi, git: "git@github.com:jeregrine/jsonapi.git"},
      {:inflex, "~> 1.9"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.3"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.test_setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
      "ecto.test_reset": ["ecto.drop", "ecto.test_setup"]
    ]
  end
end
