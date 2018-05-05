defmodule KekkaiCore do
  @moduledoc """
  Documentation for KekkaiCore.
  """

  def create_server_instance(opts)do
    KekkaiCore.Server.start_child(opts)
  end

  def hello(conn, id) when id |> is_integer() do
    conn |> KekkaiCore.Server.reply(id)
  end

  def crc_test(conn, id) do
    conn |> KekkaiCore.Server.crc_test(id)
  end
end
