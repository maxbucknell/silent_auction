defmodule SilentAuction.Api.Auth.Server do
  require Logger

  alias SilentAuction.Api.Auth.Sender
  alias SilentAuction.Api.Auth.Guardian
  alias SilentAuction.DB.Repo

  use GenServer

  def start_link(config) do
    name = Keyword.get(config, :name)
    GenServer.start_link(__MODULE__, config, name: name)
  end

  @doc """
  Begins an authentication challenge.

  Generates a code for the given credential, and sends a message with the code.

  Returns `{:ok, challenge_id}` if credential is valid and code was sent, or
  `{:error, reason}` otherwise.
  """
  def challenge(pid, recipient) do
    GenServer.call(pid, {:challenge, recipient})
  end

  @doc """
  Completes an authentication challenge.

  Receives the `challenge_id` given by `challenge/2`, and validates it.

  Returns `{:ok, recipient}` if successful, and `{:error, reason}` otherwise.
  """
  def verify(pid, challenge_id, code) do
    GenServer.call(pid, {:verify, challenge_id, code})
  end

  # Server Callbacks

  @impl GenServer
  def init(config) do
    sender = Keyword.fetch!(config, :sender)
    table = :ets.new(:auth_registry, [:set, :private])

    state = %{
      table: table,
      sender: sender
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:challenge, recipient}, _from, state) do
    %{table: table, sender: sender} = state

    with {:ok, {type, identity}} <- Sender.validate_recipient(sender, recipient),
         code <- generate_code(),
         challenge_id <- :crypto.hash(:sha256, identity),
         _ <- :ets.insert(table, {challenge_id, {type, identity}, code}),
         :ok <- Sender.send_code(sender, {type, identity}, code) do
      {:reply, {:ok, challenge_id}, state}
    else
      {:error, reason} -> {:reply, {:error, reason}, state}
      _ -> {:reply, {:error, :unknown_error}, state}
    end
  end

  @impl GenServer
  def handle_call({:verify, challenge_id, code}, _from, state) do
    %{table: table} = state

    with [{^challenge_id, {_type, identity}, ^code}] <- :ets.lookup(table, challenge_id),
         {:ok, account} <- Repo.Account.retrieve_by_phone(identity),
         {:ok, token, _} <- Guardian.encode_and_sign(account, %{}, ttl: {4, :hours}) do
      {:reply, {:ok, token}, state}
    else
      [] -> {:reply, {:error, :auth_not_started}, state}
      [{^challenge_id, _, _}] -> {:reply, {:error, :invalid_code}, state}
      _ -> {:reply, {:error, :unknown_error}, state}
    end
  end

  defp generate_code() do
    # Generate a uniform number between 100,000 and 999,999
    # (A six-digit code)
    code = :rand.uniform(900_000) + 99999
    Integer.to_string(code)
  end
end
