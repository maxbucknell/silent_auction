defmodule SilentAuction.Api.GraphQL.Schema.Types do
  use Absinthe.Schema.Notation

  @desc "User account"
  object :account do
    field(:colour, non_null(:string))
    field(:colour_name, non_null(:string))
  end

  @desc "An item up for auction"
  object :item do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
  end
end
