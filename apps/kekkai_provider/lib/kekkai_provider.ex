defmodule KekkaiProvider do
  @moduledoc """
  Documentation for KekkaiProvider.
  """

  def create_server_instance(id) when id |> is_integer do
    KekkaiProvider.Server.start_child(id)
  end

  def hello(conn, id) when id |> is_integer() do
    conn |> KekkaiProvider.Server.reply(id)
  end
end
