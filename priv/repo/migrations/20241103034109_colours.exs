defmodule SilentAuction.DB.Repo.Migrations.Colours do
  use Ecto.Migration

  def up do
    create table("colours") do
      add :name, :string,
        null: false,
        comment: "Pantone colour name"

      add :value, :bigint,
        null: false,
        comment: "Eight-bit colour stored as 0xRRGGBB00"

      add :account_id, references("accounts"),
        null: true,
        comment: "The account to whom this colour is assigned"
    end

    create index("colours", [:name], unique: true)
    create index("colours", [:value], unique: true)
    create index("colours", [:account_id], unique: true)

    create constraint("colours", :colour_valid,
      check: "value >= 0 AND value <= 0xFFFFFFFF")

    execute("ALTER TABLE colours ADD COLUMN r integer GENERATED ALWAYS AS ((value >> 24) % 256) STORED")
    execute("ALTER TABLE colours ADD COLUMN g integer GENERATED ALWAYS AS ((value >> 16) % 256) STORED")
    execute("ALTER TABLE colours ADD COLUMN b integer GENERATED ALWAYS AS ((value >> 8) % 256) STORED")

    execute("ALTER TABLE colours ADD COLUMN hex_code char(7) GENERATED ALWAYS AS ('#' || lpad(to_hex(value >> 8), 6, '0')) STORED")
  end

  def down do
    drop table("colours")
  end
end
