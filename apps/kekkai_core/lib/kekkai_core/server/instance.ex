defmodule KekkaiCore.Server.Instance do
  @moduledoc """
  The `Supervisor` which supervises one `Worker` and one `Stash`.
  This module also does user-specific jobs.
  Actually the _real_ job is passed down to the `Worker`, and its states are backed up to the `Stash`.
  When this `Instance` crashes, it doesn't restart automatically; Instead a parent `Supervisor` should
  catch it, since the parent is expected to be a `DynamicSupervisor`.
  """
  use Supervisor

  def start_link(_something, options \\ []) do
    with \
      {:ok, name} <- options |> Keyword.fetch(:process_name),
      {:ok, opts} <- options |> Keyword.fetch(:opts),
      {:ok, sup} <- Supervisor.start_link(__MODULE__, [])
    do
      start_tree(sup, name, opts)
    else
      :error ->
        {:error, "instance id or process name not given"}
      err ->
        err
    end
  end

  def start_tree(sup, name, opts) do
    with \
      {:ok, stash} <- Supervisor.start_child(sup, {__MODULE__.Stash, [opts: opts, process_name: name]}),
      {:ok, _worker} <- Supervisor.start_child(sup, {__MODULE__.WorkerSupervisor, [stash: stash]})
    do
      {:ok, sup}
    else
      # FIXME: これなんとかしたい
      {:error, {
        {:shutdown, {:failed_to_start_child, KekkaiCore.Server.Instance.Worker, {:already_started, pid}}},
        {:child, :undefined, KekkaiCore.Server.Instance.WorkerSupervisor,
            {KekkaiCore.Server.Instance.WorkerSupervisor, :start_link, [[stash: _stash_pid]]},
            :permanent, :infinity, :supervisor, [KekkaiCore.Server.Instance.WorkerSupervisor]}
      }} ->
        Process.exit(sup, :kill)
        {:error, {:already_started, pid}}
    end
  end

  def reply(process, conn), do: process |> KekkaiCore.Server.Instance.API.reply(conn)

  def init(_) do
    Supervisor.init([], strategy: :rest_for_one)
  end
end
