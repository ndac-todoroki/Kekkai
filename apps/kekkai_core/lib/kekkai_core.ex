defmodule KekkaiCore do
  @moduledoc """
  Documentation for KekkaiCore.
  """

  # TODO: functions should not require `id`s.
  # pass down only `conn`s, and parse it there.

  @spec create_server_instance(%{atom => any}) :: {:ok, pid} | {:error, any}
  def create_server_instance(%{} = opts)do
    KekkaiCore.Server.start_child(opts)
  end

  def hello(%Plug.Conn{} = conn) do
    conn |> KekkaiCore.Server.reply()
  end

  def crc_test(%Plug.Conn{} = conn) do
    conn |> KekkaiCore.Server.crc_test()
  end

  def instance_info(%Plug.Conn{} = conn), do: conn |> KekkaiCore.Server.instance_info()
end
