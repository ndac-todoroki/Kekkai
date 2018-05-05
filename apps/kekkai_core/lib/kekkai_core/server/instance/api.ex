defmodule KekkaiCore.Server.Instance.API do
  @moduledoc """
  API for KekkaiCore server instances.
  The instance worker should be called on starting instance workers,
  but use these APIs for concrete work.
  """

  #### Public APIs

  @spec reply(GenServer.name, Plug.Conn.t) :: Plug.Conn.t
  @doc """
  Performs a hello world from the given instance.
  """
  def reply(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:reply_lazy, conn})
  end

  @spec crc_test(GenServer.name, Plug.Conn.t) :: Plug.Conn.t
  @doc """
  Performs a CRC test required by Twitter's AAA Api.
  """
  def crc_test(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:crc_test, conn})
  end


  #### private functions

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
end
