defmodule Aquarium.Mixfile do
  use Mix.Project

  def project do
    [app: :aquarium,
     version: "0.5.1",
     elixir: "~> 1.9",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Aquarium, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:phoenix_html, "~> 2.14.0"},
      {:phoenix_live_reload, "~> 1.3.0", only: :dev},
      {:gettext, "~> 0.18.0"},
      {:plug_cowboy, "~> 2.5.0"},
      {:jason, "~> 1.2.0"},
      {:credo, "~> 1.5.0", only: [:dev, :test]}
    ]
  end
end
