defmodule SilentAuction.DB.Schema.BidTest do
  use SilentAuction.DBCase

  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Bid
  alias SilentAuction.DB.Schema.Account
  alias SilentAuction.DB.Schema.Item

  setup do
    account = %Account{
      phone: "61491570006",
      name: "Test Userson"
    }

    changeset = Account.changeset(account)

    {:ok, account} = Repo.insert(changeset)

    item = %Item{
      public_id: "0123456789ABCDEF",
      name: "Turntable",
      description: """
      ## Pro-Ject Primary E Phono Turntable

      Manual action 33/45rpm turntable using Ortofon cartridges, sounds great.
      My first record player, and one of which I'm very fond.
      """
    }

    changeset = Item.changeset(item)

    {:ok, item} = Repo.insert(changeset)

    %{account: account, item: item}
  end

  test "can create bid", %{account: account, item: item} do
    bid = %Bid{
      amount: 15013,
      made_at: ~U[2024-10-31T19:41:23Z],
      time_zone: "Australia/Sydney",
      account: account,
      item: item
    }

    changeset = Bid.changeset(bid)

    assert {:ok, _} = Repo.insert(changeset)
  end

  test "all fields are required", %{account: account, item: item} do
    bid = %Bid{
      made_at: ~U[2024-10-31T19:41:23Z],
      time_zone: "Australia/Sydney",
      account: account,
      item: item
    }

    changeset = Bid.changeset(bid)

    assert {:error, _} = Repo.insert(changeset)

    bid = %Bid{
      amount: 15013,
      time_zone: "Australia/Sydney",
      account: account,
      item: item
    }

    changeset = Bid.changeset(bid)

    assert {:error, _} = Repo.insert(changeset)

    bid = %Bid{
      amount: 15013,
      made_at: ~U[2024-10-31T19:41:23Z],
      account: account,
      item: item
    }

    changeset = Bid.changeset(bid)

    assert {:error, _} = Repo.insert(changeset)

    bid = %Bid{
      amount: 15013,
      made_at: ~U[2024-10-31T19:41:23Z],
      time_zone: "Australia/Sydney",
      item: item
    }

    changeset = Bid.changeset(bid)

    assert {:error, _} = Repo.insert(changeset)

    bid = %Bid{
      amount: 15013,
      made_at: ~U[2024-10-31T19:41:23Z],
      time_zone: "Australia/Sydney",
      account: account
    }

    changeset = Bid.changeset(bid)

    assert {:error, _} = Repo.insert(changeset)
  end
end
