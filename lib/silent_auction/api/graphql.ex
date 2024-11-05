defmodule SilentAuction.Api.GraphQL do
  use Plug.Builder

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:add_resource_to_context)
  plug(:add_dataloader_to_context)

  if Mix.env() != :dev do
    plug(Absinthe.Plug,
      schema: SilentAuction.Api.GraphQL.Schema
    )
  else
    plug(Absinthe.Plug.GraphiQL,
      schema: SilentAuction.Api.GraphQL.Schema
    )
  end

  defp add_resource_to_context(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      {account} -> Absinthe.Plug.assign_context(conn, :account, account)
      _ -> conn
    end
  end

  defp add_dataloader_to_context(conn, _opts) do
    loader = SilentAuction.Api.GraphQL.Dataloader.new()

    Absinthe.Plug.assign_context(conn, :loader, loader)
  end
end
