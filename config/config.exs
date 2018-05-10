# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.
import_config "../apps/*/config/config.exs"

# Sample configuration (overrides the imported configuration above):
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

# Configures the endpoints
config :kekkai_gateway, KekkaiGateway.Endpoint,
  http: [port: 4000]

config :kekkai_web, KekkaiWeb.Endpoint,
  http: [port: 4040]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Set LoggerFileBackend as file output logger.
config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :logger_file_info},
    {LoggerFileBackend, :logger_file_error},
  ]
###
config :logger, :logger_file_info,
  path: "log/#{Mix.env}/info.log",
  level: :info
###
config :logger, :logger_file_error,
  path: "log/#{Mix.env}/error.log",
  level: :error
