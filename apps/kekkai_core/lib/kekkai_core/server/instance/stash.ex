defmodule KekkaiCore.Server.Instance.Stash do
  alias KekkaiCore.Server.Instance.Settings

  use GenServer

  #### External API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, init_struct(opts))
  end

  defp init_struct([opts: %{id: id, consumer_secret: consumer_secret}, process_name: name]) do
    %Settings{
      instance_id: id,
      consumer_secret: consumer_secret,
      noise: SecureRandom.urlsafe_base64(),
      process_name: name,
    }
  end

  def get_state(pid) do
    pid |> GenServer.call(:get_value)
  end

  def update_state(pid, {key, _val} = pair) when key |> is_atom() do
    pid |> GenServer.cast({:update_state, pair})
  end


  #### GenServer implementation

  @impl GenServer
  def init(%Settings{} =args) do
    {:ok, args}
  end

  @impl GenServer
  def handle_call(:get_value, _from, %Settings{} =state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:update_state, {key, val}}, %Settings{} =state) do
    if key in Settings.permitted_keys() do
      {:noreply, %{state | key => val}}
    else
      {:noreply, state}
    end
  end
end
