defmodule KekkaiGateway.Endpoint do
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

  forward "/apps", to: KekkaiGateway.Endpoint.Apps

  post "/webhooks/:id/:noise" do
    id = id |> KekkaiGateway.Parsers.ID.parse!()

  end

  # Twitter's CRC test endpoint
  post "/webhooks/:id/:noise/:crc_token" do
    id = id |> KekkaiGateway.Parsers.ID.parse!()
    KekkaiCore.crc_test(conn, id)
  end

  match "/" do
    send_resp(conn, 200, "hello world")
  end

  match _, to: KekkaiGateway.Endpoint.NotFound
end
