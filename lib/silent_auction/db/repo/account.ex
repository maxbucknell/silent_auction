defmodule SilentAuction.DB.Repo.Account do
  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Account
  alias SilentAuction.DB.Schema.Colour

  import Ecto.Query

  def retrieve_by_phone(phone) do
    Repo.transaction(fn ->
      account = load_by_phone(phone)

      if account != nil do
        {:ok, account}
      else
        colour =
          Repo.one(
            from(c in Colour,
              where: is_nil(c.account_id),
              preload: [:account],
              limit: 1,
              lock: "FOR UPDATE SKIP LOCKED"
            )
          )

        account = %{phone: phone}

        changeset = Colour.changeset(colour, %{account: account})

        {:ok, _} = Repo.update(changeset)
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
end
