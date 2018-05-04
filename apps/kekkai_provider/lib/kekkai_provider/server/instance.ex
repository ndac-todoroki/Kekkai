defmodule KekkaiProvider.Server.Instance do
  @moduledoc """
  The `Supervisor` which supervises one `Worker` and one `Stash`.
  This module also does user-specific jobs.
  Actually the _real_ job is passed down to the `Worker`, and its states are backed up to the `Stash`.
  When this `Instance` crashes, it doesn't restart automatically; Instead a parent `Supervisor` should
  catch it, since the parent is expected to be a `DynamicSupervisor`.
  """
  use Supervisor

  alias __MODULE__.Worker, as: InstanceWorker

  def start_link(_something, opts) do
    with \
      {:ok, id} <- opts |> Keyword.fetch(:instance_id),
      {:ok, name} <- opts |> Keyword.fetch(:process_name),
      {:ok, sup} <- Supervisor.start_link(__MODULE__, [instance_id: id])
    do
      start_tree(sup, id, name)
    else
      :error ->
        {:error, "instance id or process name not given"}
      err ->
        err
    end
  end

  def start_tree(sup, id, name) do
    with \
      {:ok, stash} <- Supervisor.start_child(sup, {__MODULE__.Stash, [instance_id: id, process_name: name]}),
      {:ok, _worker} <- Supervisor.start_child(sup, {__MODULE__.WorkerSupervisor, [stash: stash]})
    do
      {:ok, sup}
    else
      # FIXME: これなんとかしたい
      {:error, {
        {:shutdown, {:failed_to_start_child, KekkaiProvider.Server.Instance.Worker, {:already_started, pid}}},
        {:child, :undefined, KekkaiProvider.Server.Instance.WorkerSupervisor,
            {KekkaiProvider.Server.Instance.WorkerSupervisor, :start_link, [[stash: _stash_pid]]},
            :permanent, :infinity, :supervisor, [KekkaiProvider.Server.Instance.WorkerSupervisor]}
      }} ->
        Process.exit(sup, :kill)
        {:error, {:already_started, pid}}
    end
  end

  def reply(process, conn), do: process |> InstanceWorker.reply(conn)

  def init(_) do
    Supervisor.init([], strategy: :rest_for_one)
  end
end
