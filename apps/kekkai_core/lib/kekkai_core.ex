defmodule KekkaiCore do
  @moduledoc """
  Documentation for KekkaiCore.
  """

  # TODO: functions should not require `id`s.
  # pass down only `conn`s, and parse it there.

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
