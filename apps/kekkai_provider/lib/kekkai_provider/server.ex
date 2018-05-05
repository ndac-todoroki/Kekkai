defmodule KekkaiCore.Server do
  @moduledoc """
  The KekkaiCore server is a cluster of multiple server instances.
  This `KekkaiCore.Server` itself is a `DynamicSupervisor` which creates
  multiple KekkaiCore server instances and keeps track of it.
  Names of the server instances are taken from `KekkaiCore.Registry` using `:via` tuples.
  """

  use DynamicSupervisor#, restart: :temporary  # children wouldn't be restarted automatically

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def reply(conn, id) do
    process_name = KekkaiCore.Application.process_name(id)

    with {:done, new_conn} <- KekkaiCore.Server.Instance.reply(process_name, conn) do
      new_conn
    else
      any ->
        any |> IO.inspect
        :error
    end
  end

  @impl DynamicSupervisor
  def init(initial_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [initial_arg]
    )
  end

  def start_child(%{id: id} = opts) do
    process_name = KekkaiCore.Application.process_name(id)
    spec = {KekkaiCore.Server.Instance, process_name: process_name, opts: opts}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} ->
        {:ok, pid}
      {:ok, pid, _info} ->
        {:ok, pid}
      {:error, reason}  when reason in [:max_children, :dynamic] ->
        {:error, :max_children}
      others ->
        others
    end
  end

  def crc_test(conn, id) do
    id
    |> KekkaiCore.Application.process_name()
    |> KekkaiCore.Server.Instance.Worker.crc_test(conn)
  end
end
