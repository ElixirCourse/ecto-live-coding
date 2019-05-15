use Mix.Config

config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "app_repo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
