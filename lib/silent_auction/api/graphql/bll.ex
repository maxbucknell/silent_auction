defmodule SilentAuction.Api.GraphQL.BLL do
  alias SilentAuction.DB.Repo.Item
  alias SilentAuction.DB.Repo.Bid
  alias SilentAuction.DB.Repo.Account

  import Absinthe.Resolution.Helpers, only: [batch: 3]

  def retrieve_items({offset, limit}) do
    {:ok, Item.load_paginated_items({offset, limit})}
  end

  def retrieve_item_by_id(item_id) do
    batch({__MODULE__, :batch_retrieve_item_by_id}, item_id, fn results ->
      {:ok, Map.get(results, item_id)}
    end)
  end

  def batch_retrieve_item_by_id(_, item_ids) do
    Item.load_items_by_ids(item_ids)
  end

  def retrieve_item_by_public_id(item_id) do
    batch({__MODULE__, :batch_retrieve_item_by_public_id}, item_id, fn results ->
      {:ok, Map.get(results, item_id)}
    end)
  end

  def batch_retrieve_item_by_public_id(_, public_ids) do
    Item.load_items_by_public_ids(public_ids)
  end

  def retrieve_bids_for_item(item_id, {offset, limit}) do
    {:ok, Bid.load_paginated_bids_for_item(item_id, {offset, limit})}
  end

  def retrieve_bids_for_account(account_id, {offset, limit}) do
    {:ok, Bid.load_paginated_bids_for_account(account_id, {offset, limit})}
  end

  def retrieve_account(account_id) do
    batch({__MODULE__, :batch_retrieve_account}, account_id, fn results ->
      {:ok, Map.get(results, account_id)}
    end)
  end

  def batch_retrieve_account(_, account_ids) do
    Account.load_accounts_by_ids(account_ids)
  end
end
