defmodule KekkaiGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :kekkai_gateway,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KekkaiGateway.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.3"},
      {:plug, "~> 1.3"},
      {:jason, "~> 1.0"},
      {:remote_ip, "~> 0.1"},
      {:inet_cidr, "~> 1.0.0"},

      {:kekkai_core, in_umbrella: true},

      # Verify JSON
      {:simple_schema, git: "https://github.com/ndac-todoroki/simple_schema/", branch: "unique_exception"},
    ]
  end
end
