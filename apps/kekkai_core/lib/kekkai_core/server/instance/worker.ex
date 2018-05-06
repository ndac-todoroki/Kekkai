defmodule KekkaiCore.Server.Instance.Worker do
  use GenServer, restart: :permanent

  alias KekkaiCore.Server.Instance.{Settings, Stash}
  alias KekkaiCore.Server.Instance.Worker.{CrcTestParser}

  import Plug.Conn

  def start_link(stash_pid) do
    with \
      %Settings{process_name: name} = settings <- Stash.get_state(stash_pid)
    do
      GenServer.start_link(__MODULE__, settings, name: name)
    else
      :error ->
        {:error, "instance id or process name not given"}
      err ->
        err
    end
  end

  #### GenServer implementations

  @impl GenServer
  def init(%Settings{} = settings) do
    {:ok, settings}
  end

  @impl GenServer
  def handle_call({:reply, conn}, _from, %Settings{instance_id: instance_id} = state) do
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
  def handle_call({:crc_test, %Plug.Conn{} = conn}, _from, %Settings{} = state) do
    params = conn.params |> CrcTestParser.parse!
    key = state.consumer_secret || raise "consumer_secret not set"
    message = params.crc_token

    response_token =
      :crypto.hmac(:sha256, key, message)
      |> Base.encode64(padding: true)

    json =
      %{response_token: "sha256:" <> response_token}
      |> Jason.encode!()

    new_conn =
      conn
      |> send_resp(200, json)

    {:reply, new_conn, state}
  end

  @impl GenServer
  def handle_call({:instance_info, conn}, _from, %Settings{} = state) do
    json =
      %{
        id: state.instance_id,
        webhook_url: state |> Settings.webhook_url(),
      }
      |> Jason.encode!()

    conn =
      conn
      |> set_body(json)
      |> send_resp()

    {:reply, conn, state}
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

  @impl GenServer
  def terminate(reason, %Settings{stash_pid: stash_pid} = state) do
    Stash.put_state(stash_pid, state)
  end


  #### private functions

  defp set_body(%Plug.Conn{resp_body: nil, state: :unset} = conn, body) do
    %{conn | resp_body: body, state: :set}
  end
end
