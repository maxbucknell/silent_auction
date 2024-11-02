defmodule SilentAuction.DB.Schema.Item do
  use Ecto.Schema

  alias SilentAuction.DB.Schema

  schema "items" do
    field(:public_id, :string)
    field(:name, :string)
    field(:description, :string)

    has_many(:bids, Schema.Bid)
  end

  def changeset(item, params \\ %{}) do
    item
    |> Ecto.Changeset.cast(params, [:public_id, :name, :description])
    |> Ecto.Changeset.validate_required([:public_id, :name, :description])
  end
end
