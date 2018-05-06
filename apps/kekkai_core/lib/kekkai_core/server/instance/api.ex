defmodule KekkaiCore.Server.Instance.API do
  @moduledoc """
  API for KekkaiCore server instances.
  The instance worker should be called on starting instance workers,
  but use these APIs for concrete work.
  """

  #### Public APIs

  @spec reply(GenServer.server, Plug.Conn.t) :: Plug.Conn.t
  @doc """
  Performs a hello world from the given instance.
  """
  def reply(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:reply_lazy, conn})
  end

  @spec crc_test(GenServer.server, Plug.Conn.t) :: Plug.Conn.t
  @doc """
  Performs a CRC test required by Twitter's AAA Api.
  """
  def crc_test(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:crc_test, conn})
  end

  @spec instance_info(GenServer.server, Plug.Conn.t) :: Plug.Conn.t
  @doc """
  Quotes with the webhook endpoint url json.
  """
  def instance_info(process, conn) do
    process
    |> verify_process!()
    |> GenServer.call({:instance_info, conn})
  end


  #### private functions

  @spec verify_process!(GenServer.server) :: GenServer.server | no_return
  # verifies if process is alive or not, and returns the process on success.
  defp verify_process!({:via, Registry, {module, name}}) do
    case Registry.lookup(module, name) do
      [] ->
        # FIXME: change this or raise custom exception so we can return better info
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
