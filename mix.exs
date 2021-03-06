defmodule KekkaiDB.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      default_task: "phx.server",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:distillery, "~> 1.0", warn_missing: false, runtime: false},
      {:logger_file_backend, "~> 0.0.10"},
    ]
  end
end
