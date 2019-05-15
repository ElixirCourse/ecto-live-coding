use Mix.Config

config :app, ecto_repos: [App.Repo]

config :app, App.Repo,
  database: "app_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

import_config("#{Mix.env()}.exs")
