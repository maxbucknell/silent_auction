defmodule SilentAuction.Api.GraphQL.Schema do
  use Absinthe.Schema

  alias SilentAuction.Api.GraphQL.BLL

  import_types(SilentAuction.Api.GraphQL.Schema.Types)

  query do
    field :account, :account do
      resolve(fn _, _, %{context: context} ->
        case context do
          %{account: account} -> {:ok, account}
          _ -> {:error, :not_logged_in}
        end
      end)
    end

    field :bids, list_of(:bid) do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)

      resolve(fn _, %{offset: offset, limit: limit}, %{context: context} ->
        case context do
          %{account: account} ->
            BLL.retrieve_bids_for_account(account.id, {offset, limit})

          _ ->
            {:error, :not_logged_in}
        end
      end)
    end

    field :items, list_of(:item) do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)

      resolve(fn _, %{offset: offset, limit: limit}, _ ->
        BLL.retrieve_items({offset, limit})
      end)
    end

    field :item, :item do
      arg(:id, :id)

      resolve(fn _, %{id: id}, _ ->
        BLL.retrieve_item_by_public_id(id)
      end)
    end
  end

  mutation do
    field :make_bid, type: :bid do
      arg(:item, non_null(:id))
      arg(:amount, non_null(:integer))

      resolve(&SilentAuction.Api.GraphQL.Mutations.make_bid/3)
    end
  end
end
