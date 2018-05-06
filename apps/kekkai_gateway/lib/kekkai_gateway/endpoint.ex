defmodule KekkaiGateway.Endpoint do
  @moduledoc """
  The root endpoint for the Kekkai Server application.
  """

  use Plug.Router

  # Get the original IP
  plug RemoteIp

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

  forward "/webhooks", to: KekkaiGateway.Endpoint.Webhooks

  match "/" do
    send_resp(conn, 200, "hello world")
  end

  match _, to: KekkaiGateway.Endpoint.NotFound
end
