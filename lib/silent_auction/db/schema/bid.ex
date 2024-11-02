defmodule SilentAuction.DB.Schema.Bid do
  use Ecto.Schema

  alias SilentAuction.DB.Schema

  schema "bids" do
    field(:amount, :integer)
    field(:made_at, :utc_datetime)
    field(:time_zone, :string)

    belongs_to(:account, Schema.Account)
    belongs_to(:item, Schema.Item)
  end

  def changeset(bid, params \\ %{}) do
    bid
    |> Ecto.Changeset.cast(params, [:amount, :made_at, :time_zone])
    |> Ecto.Changeset.cast_assoc(:account, with: &Schema.Account.changeset/2)
    |> Ecto.Changeset.cast_assoc(:item, with: &Schema.Item.changeset/2)
    |> Ecto.Changeset.validate_required([:amount, :made_at, :time_zone, :account, :item])
  end
end
