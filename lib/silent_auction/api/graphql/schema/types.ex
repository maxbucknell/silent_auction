defmodule SilentAuction.Api.GraphQL.Schema.Types do
  use Absinthe.Schema.Notation

  @desc "An item up for auction"
  object :item do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
    field(:price, :integer, description: "Price required for immediate purchase")
  end
end
