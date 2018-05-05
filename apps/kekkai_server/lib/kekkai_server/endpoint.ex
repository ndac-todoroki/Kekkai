defmodule KekkaiServer.Endpoint do
  @moduledoc """
  The root endpoint for the Kekkai Server application.
  """

  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.Logger

  # set default to json
  plug Plug.DefaultRespContentType, "application/json"

  plug Plug.Parsers,
          parsers: [:urlencoded, :json],
          pass:  ["text/*"],
          json_decoder: Jason
  plug :match
  plug :dispatch

  def init([port: port]) do
    Logger.info("* Cowboy started on port #{port}")
  end

  forward "/apps", to: KekkaiServer.Endpoint.Apps

  post "/webhooks/:id/:noise" do
    id = id |> KekkaiServer.Parsers.ID.parse!()

  end

  # Twitter's CRC test endpoint
  post "/webhooks/:id/:noise/:crc_token" do
    id = id |> KekkaiServer.Parsers.ID.parse!()
    KekkaiCore.crc_test(conn, id)
  end

  match "/" do
    send_resp(conn, 200, "hello world")
  end

  match _, to: KekkaiServer.Endpoint.NotFound
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
