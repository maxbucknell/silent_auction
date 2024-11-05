import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :silent_auction,
  time_zone: "Australia/Sydney"

config :silent_auction, SilentAuction.DB.Repo,
  database: System.fetch_env!("PGDATABASE"),
  username: System.fetch_env!("PGUSER"),
  password: System.fetch_env!("PGPASSWORD"),
  hostname: System.fetch_env!("PGHOST"),
  port: System.fetch_env!("PGPORT")

config :silent_auction, SilentAuction.Api.Auth.Guardian,
  secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")

config :silent_auction, ecto_repos: [SilentAuction.DB.Repo]

import_config "#{config_env()}.exs"
