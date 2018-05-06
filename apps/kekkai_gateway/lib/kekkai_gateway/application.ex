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
      {Plug.Adapters.Cowboy2, scheme: :http, plug: {KekkaiGateway.Endpoint, cowboy_options()}, options: cowboy_options()},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KekkaiGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_options do
     Application.fetch_env!(:kekkai_gateway, KekkaiGateway.Endpoint)[:http]
  end
end
