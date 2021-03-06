defmodule KekkaiCore.Server do
  @moduledoc """
  The KekkaiCore server is a cluster of multiple server instances.
  This `KekkaiCore.Server` itself is a `DynamicSupervisor` which creates
  multiple KekkaiCore server instances and keeps track of it.
  Names of the server instances are taken from `KekkaiCore.Registry` using `:via` tuples.
  """

  defmodule Parser do
    defmodule ID do
      import SimpleSchema, only: [defschema: 2]

      defschema [
        id: SimpleSchema.Type.IntegerString,
      ], tolerant: true
    end
  end


  use DynamicSupervisor#, restart: :temporary  # children wouldn't be restarted automatically

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl DynamicSupervisor
  def init(initial_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [initial_arg]
    )
  end

  @doc """
  Starts a new `KekkaiCore.Server.Instance`. Returns its pid.
  """
  # TODO: change argument to struct type?
  @spec start_child(%{id: integer, consumer_secret: String.t}) :: {:ok, pid} | {:error, term}
  def start_child(%{id: id, consumer_secret: secret} = opts) do
    process_name = KekkaiCore.Application.process_name(id)
    spec = {
      KekkaiCore.Server.Instance,
      process_name: process_name,
      opts: opts # do something to assume map contents
    }

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

  def reply(conn) do
    with {:ok, %{id: id}} <- SimpleSchema.from_json(Parser.ID, conn.params) do
      id
      |> KekkaiCore.Application.process_name()
      |> KekkaiCore.Server.Instance.reply(conn)
    else
      {:error, reasons} ->
        conn
        |> SimpleSchema.Utilities.ErrorsToPlug.set_body(reasons)
        |> Plug.Conn.put_status(422)
        |> Plug.Conn.send_resp()
    end
  end

  def crc_test(conn) do
    with {:ok, %{id: id}} <- SimpleSchema.from_json(Parser.ID, conn.params) do
      id
      |> KekkaiCore.Application.process_name()
      |> KekkaiCore.Server.Instance.API.crc_test(conn)
    else
      {:error, reasons} ->
        conn
        |> SimpleSchema.Utilities.ErrorsToPlug.set_body(reasons)
        |> Plug.Conn.put_status(422)
        |> Plug.Conn.send_resp()
    end
  end

  def instance_info(conn) do
    with {:ok, %{id: id}} <- SimpleSchema.from_json(Parser.ID, conn.params) do
      id
      |> KekkaiCore.Application.process_name()
      |> KekkaiCore.Server.Instance.API.instance_info(conn)
    else
      {:error, reasons} ->
        conn
        |> SimpleSchema.Utilities.ErrorsToPlug.set_body(reasons)
        |> Plug.Conn.put_status(422)
        |> Plug.Conn.send_resp()
    end
  end
end
