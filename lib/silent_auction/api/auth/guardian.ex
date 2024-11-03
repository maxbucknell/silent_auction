defmodule SilentAuction.Api.Auth.Guardian do
  use Guardian, otp_app: :silent_auction

  alias SilentAuction.DB.Repo

  @impl Guardian
  def subject_for_token(account, _claims) do
    {:ok, account.colour.name}
  end

  @impl Guardian
  def resource_from_claims(%{"sub" => colour_name}) do
    case Repo.Account.load_by_colour(colour_name) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end
end
