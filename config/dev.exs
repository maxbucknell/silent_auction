import Config

config :silent_auction, SilentAuction.Api.Auth.Sender,
  sender: SilentAuction.Api.Auth.Sender.LogSender,
  level: :notice

config :silent_auction, SilentAuction.Api.Auth.Guardian, issuer: "xyz.mpwb.dev.silent-auction"
