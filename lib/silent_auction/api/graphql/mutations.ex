defmodule SilentAuction.Api.GraphQL.Mutations do
  alias SilentAuction.DB.Repo.Bid

  def make_bid(_, %{item: item, amount: amount}, %{context: %{account: account}}) do
    case IO.inspect(Bid.create_new_bid(account, item, amount)) do
      {:ok, bid} -> {:ok, bid}
      {:error, _} -> {:error, :bid_too_low}
    end
  end

  def make_bid(_, _, _) do
    {:error, :not_logged_in}
  end
end
