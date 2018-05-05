defmodule KekkaiServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :kekkai_server,
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
      mod: {KekkaiServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.3"},
      {:plug, "~> 1.3"},
      {:jason, "~> 1.0"},

      # Verify JSON
      {:simple_schema, git: "https://github.com/ndac-todoroki/simple_schema/", branch: "unique_exception"},
    ]
  end
end
