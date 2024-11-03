import Config

config :silent_auction, SilentAuction.Api.Auth.Sender,
  sender: SilentAuction.Api.Auth.Sender.MapSender

config :silent_auction, SilentAuction.DB.Repo,
  database: "#{System.get_env("PGDATABASE")}_test",
  pool: Ecto.Adapters.SQL.Sandbox
