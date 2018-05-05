defmodule KekkaiGateway.Endpoint.Apps do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  alias __MODULE__

  plug Plug.Parsers,
          parsers: [:urlencoded, :json],
          pass:  ["text/*"],
          json_decoder: Jason
  plug :match
  plug :dispatch

  post "/" do
    params = conn.body_params |> Apps.CreateParser.parse!()

    with \
      {:ok, _pid} <- KekkaiCore.create_server_instance(params)
    do
      conn
      |> put_status(201)
      |> KekkaiCore.instance_info(params.id)
    else
      {:error, :max_children} ->
        send_resp(conn, 500, "No more instances could be created. Please report this to us. Thanks.")
      {:error, {:already_started, _pid}} ->
        send_resp(conn, 409, "The instance with that name is already UP! Make sure your request is correct.")
    end
  end

  get "/:id" do
    id = id |> KekkaiGateway.Parsers.ID.parse!()
    conn |> KekkaiCore.hello(id)
  end

  match _, to: KekkaiGateway.Endpoint.NotFound

  def handle_errors(conn, %{kind: :error, reason: %SimpleSchema.FromJsonError{} = reason, stack: _stack}) do
    json =
      %{
        errors: %{
          error: "Request parameter was wrong.",
          details: reason.reason |> Enum.map(fn {reason, place} -> %{position: place, reason: reason} end)
        }
      }
      |> Jason.encode!

    conn
    |> send_resp(conn.status, json)
  end

  def handle_errors(conn, _assigns) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(conn.status, "Something went wrong")
  end
end
