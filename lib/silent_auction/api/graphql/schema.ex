defmodule SilentAuction.Api.GraphQL.Schema do
  use Absinthe.Schema

  import_types(SilentAuction.Api.GraphQL.Schema.Types)

  query do
    field :account, :account do
      resolve(fn _, _, %{context: context} ->
        case context do
          %{account: account} ->
            {:ok,
             %{
               colour: account.colour.hex_code,
               colour_name: account.colour.name
             }}

          _ ->
            {:error, :not_logged_in}
        end
      end)
    end
  end
end
