defmodule SilentAuction.Api.GraphQL.Schema.Types do
  use Absinthe.Schema.Notation

  alias SilentAuction.Api.GraphQL.BLL

  @desc "User account"
  object :account do
    field :id, :id do
      resolve(fn account, _, _ ->
        case account do
          %{colour: %{name: name}} -> {:ok, name}
          _ -> {:error, :account_not_loaded}
        end
      end)
    end

    field :colour, non_null(:string) do
      resolve(fn account, _, _ ->
        case account do
          %{colour: %{hex_code: hex_code}} -> {:ok, hex_code}
          _ -> {:error, :account_not_loaded}
        end
      end)
    end
  end

  @desc "An item up for auction"
  object :item do
    field :id, :id do
      resolve(fn %{public_id: public_id}, _, _ -> {:ok, public_id} end)
    end

    field(:name, :string)
    field(:description, :string)

    field :bids, list_of(:bid) do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)

      resolve(fn %{id: id}, %{offset: offset, limit: limit}, _ ->
        BLL.retrieve_bids_for_item(id, {offset, limit})
      end)
    end
  end

  @desc "A bid, by an account, on an item"
  object :bid do
    field(:amount, :integer)

    field :made_at, :string do
      resolve(fn %{made_at: made_at, time_zone: time_zone}, _, _ ->
        case DateTime.shift_zone(made_at, time_zone) do
          {:ok, local_made_at} -> {:ok, DateTime.to_iso8601(local_made_at)}
          _ -> {:error, :invalid_time}
        end
      end)
    end

    field :account, :account do
      resolve(fn %{account_id: account_id}, _, _ ->
        BLL.retrieve_account(account_id)
      end)
    end

    field :item, :item do
      resolve(fn %{item_id: item_id}, _, _ ->
        BLL.retrieve_item_by_id(item_id)
      end)
    end
  end
end
