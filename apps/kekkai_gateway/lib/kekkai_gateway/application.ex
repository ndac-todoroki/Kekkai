defmodule KekkaiGateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: KekkaiGateway.Worker.start_link(arg)
      # {KekkaiGateway.Worker, arg},
      {Plug.Adapters.Cowboy2, scheme: :http, plug: {KekkaiGateway.Endpoint, port: 4000}, options: [port: 4000]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KekkaiGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
