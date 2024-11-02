defmodule SilentAuction.DB.Repo do
  use Ecto.Repo,
    otp_app: :silent_auction,
    adapter: Ecto.Adapters.Postgres
end
