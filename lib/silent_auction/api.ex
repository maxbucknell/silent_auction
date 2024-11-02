defmodule SilentAuction.Api do
  use Plug.Router

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
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
end
