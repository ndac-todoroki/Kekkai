# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kekkai_web,
  namespace: KekkaiWeb,
  ecto_repos: [KekkaiDB.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :kekkai_web, KekkaiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1JfZDUNZ8vbOyA3Gy+cUub8ztPepqw8dCo4rqMTXyBliDm6xKpqrENj8jFQe7lu4",
  render_errors: [view: KekkaiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KekkaiWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :kekkai_web, :generators,
  context_app: :kekkai_db

config :phoenix, :json_library, Jason

config :kekkai_web, MyApp.Guardian,
       issuer: "kekkai_web",
       secret_key: "IAiRDFLE9ng45znaLdaSeak+IHx9kZ+CBiKVK3zCWA+1UCV7T1I1T0y9fqUlo+8g"

config :ueberauth, Ueberauth,
  providers: [
    twitter: {Ueberauth.Strategy.Twitter, []},
  ]

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
