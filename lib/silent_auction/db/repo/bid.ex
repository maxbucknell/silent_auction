defmodule SilentAuction.DB.Repo.Bid do
  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Bid
  alias SilentAuction.DB.Schema.Item

  import Ecto.Query

  def load_paginated_bids_for_item(item_id, {offset, limit}) do
    q =
      from(b in Bid,
        offset: ^offset,
        limit: ^limit,
        where: b.item_id == ^item_id,
        order_by: [desc: :made_at]
      )

    Repo.all(q)
  end

  def load_paginated_bids_for_account(account_id, {offset, limit}) do
    q =
      from(b in Bid,
        offset: ^offset,
        limit: ^limit,
        where: b.account_id == ^account_id,
        order_by: [desc: :made_at]
      )

    Repo.all(q)
  end

  def create_new_bid(account, item_public_id, amount) do
    Repo.transaction(fn repo ->
      # Acquire a lock on the current highest bid, so that other new bids will
      # have to wait, and be validated against the new bid, hopefully making
      # race conditions impossible
      max_bid =
        Repo.one(
          from(b in Bid,
            inner_join: i in Item,
            on: i.id == b.item_id,
            where: i.public_id == ^item_public_id,
            preload: [item: i],
            limit: 1,
            order_by: [desc: :made_at],
            lock: "FOR UPDATE"
          )
        )

      made_at = DateTime.utc_now()
      time_zone = Application.fetch_env!(:silent_auction, :time_zone)

      new = %Bid{
        account: account,
        item: max_bid.item
      }

      params = %{
        amount: amount,
        made_at: made_at,
        time_zone: time_zone
      }

      changeset = Bid.changeset(max_bid, new, params)

      case repo.insert(changeset) do
        {:ok, bid} -> bid
        {:error, %{errors: errors}} -> repo.rollback(errors)
      end
    end)
  end
end
