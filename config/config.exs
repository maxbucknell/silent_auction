import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :silent_auction,
  time_zone: "Australia/Sydney"

config :silent_auction, SilentAuction.DB.Repo,
  database: System.get_env("PGDATABASE"),
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  hostname: System.get_env("PGHOST"),
  port: System.get_env("PGPORT")

config :silent_auction, ecto_repos: [SilentAuction.DB.Repo]

import_config "#{config_env()}.exs"
