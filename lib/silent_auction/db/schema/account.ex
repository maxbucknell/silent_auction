defmodule SilentAuction.DB.Schema.Account do
  use Ecto.Schema

  alias SilentAuction.DB.Schema

  schema "accounts" do
    field(:public_id, :string)
    field(:phone, :string)
    field(:name, :string)

    has_many(:bids, Schema.Bid)
  end

  def changeset(account, params \\ %{}) do
    account
    |> Ecto.Changeset.cast(params, [:public_id, :phone, :name])
    |> Ecto.Changeset.validate_required([:public_id, :phone, :name])
    |> Ecto.Changeset.validate_format(:phone, ~r/^\d{1,15}$/)
  end
end
