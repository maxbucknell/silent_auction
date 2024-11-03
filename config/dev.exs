import Config

config :silent_auction, SilentAuction.Api.Auth.Sender,
  sender: SilentAuction.Api.Auth.Sender.LogSender,
  level: :notice
