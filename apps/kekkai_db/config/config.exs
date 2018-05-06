use Mix.Config

config :kekkai_db, ecto_repos: [KekkaiDB.Repo]

import_config "#{Mix.env}.exs"
