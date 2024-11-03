defmodule SilentAuction.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    auth_sender_arg =
      Application.fetch_env!(
        :silent_auction,
        SilentAuction.Api.Auth.Sender
      )

    children = [
      {Bandit, plug: SilentAuction.Api},
      SilentAuction.DB.Repo,
      {SilentAuction.Api.Auth.Sender, auth_sender_arg ++ [name: SilentAuction.Api.Auth.Sender]},
      {SilentAuction.Api.Auth.Server,
       sender: SilentAuction.Api.Auth.Sender, name: SilentAuction.Api.Auth.Server}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SilentAuction.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
