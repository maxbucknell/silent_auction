defmodule SilentAuction.DB.Repo.Item do
  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Item

  import Ecto.Query

  def load_paginated_items({offset, limit}) do
    q =
      from(i in Item,
        offset: ^offset,
        limit: ^limit,
        order_by: [desc: :id]
      )

    Repo.all(q)
  end

  def load_items_by_ids(ids) do
    q =
      from(i in Item,
        where: i.id in ^ids
      )

    items = Repo.all(q)

    Map.new(items, fn item -> {item.id, item} end)
  end

  def load_items_by_public_ids(public_ids) do
    q =
      from(i in Item,
        where: i.public_id in ^public_ids
      )

    items = Repo.all(q)

    Map.new(items, fn item -> {item.public_id, item} end)
  end
end
