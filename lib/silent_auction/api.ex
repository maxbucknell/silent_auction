defmodule SilentAuction.Api do
  use Plug.Router

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)

  plug(Guardian.Plug.Pipeline,
    otp_app: :silent_auction,
    error_handler: SilentAuction.Api.Auth.Guardian.ErrorHandler,
    module: SilentAuction.Api.Auth.Guardian
  )

  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})

  plug(Guardian.Plug.LoadResource, allow_blank: true)

  forward("/auth", to: SilentAuction.Api.Auth)

  plug(:add_resource_to_context)

  plug(:dispatch)

  forward("/graphql",
    to: Absinthe.Plug,
    init_opts: [schema: SilentAuction.Api.GraphQL.Schema]
  )

  if Mix.env() == :dev do
    forward("/graphiql",
      to: Absinthe.Plug.GraphiQL,
      init_opts: [schema: SilentAuction.Api.GraphQL.Schema]
    )
  end

  defp add_resource_to_context(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      {account} -> Absinthe.Plug.assign_context(conn, :account, account)
      _ -> conn
    end
  end
end
