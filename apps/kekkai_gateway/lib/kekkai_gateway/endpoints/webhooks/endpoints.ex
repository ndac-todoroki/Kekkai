defmodule KekkaiGateway.Endpoint.Webhooks do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.FilterByIP, ~w(127.0.0.1 199.59.148.0/22 199.16.156.0/22)

  plug Plug.Parsers,
          parsers: [:urlencoded, :json],
          pass:  ["text/*"],
          json_decoder: Jason
  plug :match
  plug :dispatch

  post "/:id/:noise" do

  end

  # Twitter's CRC test endpoint
  get "/:id/:noise" do
    KekkaiCore.crc_test(conn)
  end

  match _, to: KekkaiGateway.Endpoint.NotFound
end
