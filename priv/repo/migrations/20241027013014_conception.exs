defmodule SilentAuction.DB.Repo.Migrations.Conception do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :phone, :string,
        size: 15,
        null: false,
        comment: "E.164 normalised phone number"

      add :name, :string,
        null: true,
        comment: "Identifiable name of person"
    end

    create index("accounts", [:phone], unique: true)

    create table("items") do
      add :public_id, :string,
        null: false,
        size: 16,
        comment: "URL friendly identifier for items"

      add :name, :string,
        null: false,
        comment: "Human-readable name of item for auction"

      add :description, :string,
        mull: false,
        comment: "Markdown text for item description"
    end

    create index("items", [:public_id], unique: true)

    create table("bids") do
      add :amount, :integer, null: false, comment: "Value of bid"

      add :made_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :time_zone, :string, null: false

      add :account_id, references("accounts")

      add :item_id, references("items")
    end

    create index("bids", ["made_at DESC"])
    create index("bids", [:item_id])

    create constraint("bids", :bid_non_negative, check: "amount >= 0")
    create constraint("bids", :time_zone_is_valid,
      check: "(now() at time zone time_zone is not Null)")
  end
end
