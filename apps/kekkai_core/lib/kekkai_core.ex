defmodule KekkaiCore do
  @moduledoc """
  Documentation for KekkaiCore.
  """

  # TODO: functions should not require `id`s.
  # pass down only `conn`s, and parse it there.

  def create_server_instance(%Plug.Conn{} = conn)do
    KekkaiCore.Server.start_child(conn)
  end

  def hello(%Plug.Conn{} = conn) do
    conn |> KekkaiCore.Server.reply()
  end

  def crc_test(%Plug.Conn{} = conn) do
    conn |> KekkaiCore.Server.crc_test()
  end

  def instance_info(%Plug.Conn{} = conn), do: conn |> KekkaiCore.Server.instance_info()
end
