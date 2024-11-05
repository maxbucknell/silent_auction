defmodule SilentAuction.DB.Repo.Account do
  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Account
  alias SilentAuction.DB.Schema.Colour

  import Ecto.Query

  def retrieve_by_phone(phone) do
    Repo.transaction(fn repo ->
      account = load_by_phone(phone)

      if account != nil do
        {:ok, account}
      else
        colour =
          repo.one(
            from(c in Colour,
              where: is_nil(c.account_id),
              preload: [:account],
              limit: 1,
              lock: "FOR UPDATE SKIP LOCKED"
            )
          )

        account = %{phone: phone}

        changeset = Colour.changeset(colour, %{account: account})

        repo.update!(changeset)
      end
    end)

    case load_by_phone(phone) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp load_by_phone(phone) do
    Repo.one(
      from(a in Account,
        where: a.phone == ^phone,
        preload: [:colour]
      )
    )
  end

  def load_by_colour(colour_name) do
    Repo.one(
      from(a in Account,
        inner_join: c in Colour,
        on: a.id == c.account_id,
        select: {a},
        where: c.name == ^colour_name,
        preload: [colour: c]
      )
    )
  end

  def load_accounts_by_ids(ids) do
    q =
      from(a in Account,
        where: a.id in ^ids,
        preload: [:colour]
      )

    accounts = Repo.all(q)

    Map.new(accounts, fn account -> {account.id, account} end)
  end
end
