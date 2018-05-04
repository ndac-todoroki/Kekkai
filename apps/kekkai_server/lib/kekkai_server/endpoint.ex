defmodule KekkaiServer.Endpoint do
  @moduledoc """
  The root endpoint for the Kekkai Server application.
  """

  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  def init([port: port]) do
    Logger.info("* Cowboy started on port #{port}")
  end

  post "/slave/:id" do
    id = id |> KekkaiServer.Parsers.ID.parse!()

    with \
      {:ok, _pid} <- KekkaiProvider.create_server_instance(id)
    do
      send_resp(conn, 201, "#{id} was created")
    else
      {:error, :max_children} ->
        send_resp(conn, 500, "No more instances could be created. Please report this to us. Thanks.")
      {:error, {:already_started, _pid}} ->
        send_resp(conn, 409, "The instance with that name is already UP! Make sure your request is correct.")
    end
  end

  get "/slave/:id" do
    id = id |> KekkaiServer.Parsers.ID.parse!()
    conn |> KekkaiProvider.hello(id)
  end

  match "/" do
    send_resp(conn, 200, "hello world")
  end
end

defmodule KekkaiServer.Parsers.ID do
  defmodule ParseError do
    defexception [
      message: "The URL format is wrong.",
      plug_status: 422,
    ]
  end

  def parse!(id) when is_binary(id) do
    id
    |> Integer.parse()
    |> judge_parse!()
  end

  defp judge_parse!({id, ""}), do: id
  defp judge_parse!(_), do: raise ParseError
end
