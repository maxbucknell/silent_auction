defmodule SilentAuction.DB.Schema.Account do
  use Ecto.Schema

  alias SilentAuction.DB.Schema

  schema "accounts" do
    field(:phone, :string)
    field(:name, :string)

    has_one(:colour, Schema.Colour)
    has_many(:bids, Schema.Bid)
  end

  def changeset(account, params \\ %{}) do
    account
    |> Ecto.Changeset.cast(params, [:phone, :name])
    |> Ecto.Changeset.validate_required([:phone])
    |> Ecto.Changeset.validate_format(:phone, ~r/^\d{1,15}$/)
  end
end
