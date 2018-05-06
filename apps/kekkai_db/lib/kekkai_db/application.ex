defmodule KekkaiDB.Application do
  @moduledoc """
  The Kekkai Application Service.

  The kekkai system business domain lives in this application.

  Exposes API to clients such as the `KekkaiWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(KekkaiDB.Repo, []),
    ], strategy: :one_for_one, name: KekkaiDB.Supervisor)
  end
end
