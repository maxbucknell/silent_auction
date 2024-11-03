defmodule SilentAuction.DB.Schema.AccountTest do
  use SilentAuction.DBCase

  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Account

  test "can create an account" do
    account = %Account{
      phone: "61491570006"
    }

    changeset = Account.changeset(account)

    assert {:ok, _} = Repo.insert(changeset)
  end

  test "phone is required" do
    account = %Account{}

    changeset = Account.changeset(account)

    assert {:error, _} = Repo.insert(changeset)
  end

  test "phone is not longer than 15 digits" do
    account = %Account{}

    changeset = Account.changeset(account, %{phone: "111111111111111"})

    assert changeset.valid? == true

    changeset = Account.changeset(account, %{phone: "1111111111111111"})

    assert !changeset.valid?
  end

  test "phone may only contain digits" do
    account = %Account{}

    changeset = Account.changeset(account, %{phone: "1234567890"})

    assert changeset.valid?

    changeset = Account.changeset(account, %{phone: "+1234567890"})

    assert !changeset.valid?
  end
end
