defmodule SilentAuction.Api.GraphQL.Schema do
  use Absinthe.Schema

  import_types(SilentAuction.Api.GraphQL.Schema.Types)

  query do
    @desc "Retrieve all items up for auction"
    field :items, list_of(:item) do
      resolve(fn _, _, _ ->
        {
          :ok,
          [
            %{
              id: "ottoman",
              name: "Yellow Four-Legged Ottoman",
              description: """
              Beautiful free-standing footstool, with a soft cushion and yellow lining.

              In good, though loved condition.
              """,
              price: 3500
            }
          ]
        }
      end)
    end
  end
end
