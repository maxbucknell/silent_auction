defmodule SilentAuction.Api do
  use Plug.Router

  plug(Plug.Logger)

  plug(Guardian.Plug.Pipeline,
    otp_app: :silent_auction,
    error_handler: SilentAuction.Api.Auth.Guardian.ErrorHandler,
    module: SilentAuction.Api.Auth.Guardian
  )

  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: true)

  plug(:match)
  plug(:dispatch)

  forward("/auth", to: SilentAuction.Api.Auth)

  forward("/graphql", to: SilentAuction.Api.GraphQL)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
