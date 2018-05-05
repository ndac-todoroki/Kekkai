defmodule KekkaiGateway.Endpoint.NotFound do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Parsers,
          parsers: [:urlencoded, :json],
          pass:  ["text/*"],
          json_decoder: Jason
  plug :match
  plug :dispatch

  # pre-compiled 404 json
  @__404__ %{errors: %{detail: "not found"}} |> Jason.encode!()

  match _ do
    conn
    |> send_resp(404, @__404__)
  end
end
