defmodule SilentAuction.DB.Schema.ItemTest do
  use SilentAuction.DBCase

  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Item

  test "can create an item" do
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

    assert {:ok, _} = Repo.insert(changeset)
  end

  test "all main fields are required" do
    item = %Item{
      name: "Turntable",
      description: """
      ## Pro-Ject Primary E Phono Turntable

      Manual action 33/45rpm turntable using Ortofon cartridges, sounds great.
      My first record player, and one of which I'm very fond.
      """
    }

    changeset = Item.changeset(item)

    assert {:error, _} = Repo.insert(changeset)

    item = %Item{
      public_id: "0123456789ABCDEF",
      description: """
      ## Pro-Ject Primary E Phono Turntable

      Manual action 33/45rpm turntable using Ortofon cartridges, sounds great.
      My first record player, and one of which I'm very fond.
      """
    }

    changeset = Item.changeset(item)

    assert {:error, _} = Repo.insert(changeset)

    item = %Item{
      public_id: "0123456789ABCDEF",
      name: "Turntable"
    }

    changeset = Item.changeset(item)

    assert {:error, _} = Repo.insert(changeset)
  end
end
