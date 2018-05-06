use Mix.Config

# Configure your database
config :kekkai_db, KekkaiDB.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kekkai_db_dev",
  hostname: "localhost",
  pool_size: 10
