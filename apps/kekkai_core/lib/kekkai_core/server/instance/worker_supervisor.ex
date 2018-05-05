defmodule KekkaiCore.Server.Instance.WorkerSupervisor do
  alias KekkaiCore.Server.Instance.Worker, as: Worker

  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(opts) do
    with {:ok, stash_pid} <- Keyword.fetch(opts, :stash) do
      children = [
        {Worker, stash_pid}
      ]

      Supervisor.init(children, strategy: :one_for_one)
    else
      :error -> {:error, "stash_pid not defined in opts"}
    end
  end
end
