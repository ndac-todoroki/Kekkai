defmodule KekkaiProvider.Server.Instance.Worker do
  use GenServer, restart: :permanent
  alias KekkaiProvider.Server.Instance.{Settings, Stash}

  def start_link(stash_pid) do
    with \
      %Settings{instance_id: id, process_name: name} <- Stash.get_state(stash_pid)
    do
      GenServer.start_link(__MODULE__, id, name: name)
    else
      :error ->
        {:error, "instance id or process name not given"}
      err ->
        err
    end
  end

  def reply(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:reply_lazy, conn})
  end

  defp verify_process!({:via, Registry, {module, name}}) do
    case Registry.lookup(module, name) do
      [] ->
        raise "There's no process currently associated with the given name!"
      [{pid, _}] ->
        verify_process!(pid)
    end
  end
  defp verify_process!(pid) when pid |> is_pid() do
    if Process.alive?(pid) do
      pid
    else
      raise "Pid not alive!"
    end
  end

  #### GenServer implementations

  @impl GenServer
  def init(instance_id) do
    state = %{instance_id: instance_id}
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:reply, conn}, _from, %{instance_id: instance_id} = state) do
    new_conn =
      conn
      |> Plug.Conn.put_resp_header("X-From", instance_id)
      |> Plug.Conn.send_resp(200, "hello world from slave instance #{instance_id}")

    {:reply, new_conn, state}
  end

  @impl GenServer
  def handle_call({:reply_lazy, conn}, from, state) do
    Process.send_after(self(), {:do_reply, conn, from}, 0)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:do_reply, conn, from}, %{instance_id: instance_id} = state) do
    new_conn =
      conn
      |> Plug.Conn.put_resp_header("X-From", instance_id |> to_string)
      |> Plug.Conn.send_resp(200, "Hello World: from instance #{instance_id}'s worker")

    GenServer.reply(from, {:done, new_conn})
    {:noreply, state}
  end
end
