defmodule KekkaiGateway.Endpoint.Apps do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug Plug.Parsers,
          parsers: [:urlencoded, :json],
          pass:  ["text/*"],
          json_decoder: Jason
  plug :match
  plug :dispatch

  defmodule Parser do
    defmodule ChildOpts do
      import SimpleSchema, only: [defschema: 2]

      defschema [
        id: SimpleSchema.Type.IntegerString,
        consumer_secret: :string,
      ], tolerant: true
    end
  end

  post "/" do
    with \
      {:ok, opts} <- SimpleSchema.from_json(Parser.ChildOpts, conn.params),
      {:ok, _pid} <- opts |> KekkaiCore.create_server_instance()
    do
      conn
      |> put_status(201)
      |> KekkaiCore.instance_info()
    else
      {:error, :max_children} ->
        send_resp(conn, 500, "No more instances could be created. Please report this to us. Thanks.")
      {:error, {:already_started, _pid}} ->
        send_resp(conn, 409, "The instance with that name is already UP! Make sure your request is correct.")
      {:error, reasons} when reasons |> is_list ->
        conn
        |> SimpleSchema.Utilities.ErrorsToPlug.set_body(reasons)
        |> Plug.Conn.put_status(422)
        |> Plug.Conn.send_resp()
        |> Plug.Conn.halt()
      {:error, _} ->
        raise "Unexpected error" # triggers text return
    end
  end

  get "/:id" do
    conn
    |> put_status(200)
    |> KekkaiCore.instance_info()
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
