alias SilentAuction.Api.Auth.Sender

defmodule Sender.MapSender do
  @moduledoc """
  Implements sender by writing to a map. Also supports blocking.

  Used for testing.
  """

  use GenServer

  def lookup(pid, recipient) do
    GenServer.call(pid, {:lookup, recipient})
  end

  def put_invalid_recipient(pid, recipient) do
    GenServer.call(pid, {:put_invalid_recipient, recipient})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{codes: %{}, invalid: MapSet.new()}}
  end

  def handle_call({:lookup, recipient}, _from, state) do
    %{codes: codes} = state

    {:reply, Map.fetch(codes, recipient), state}
  end

  def handle_call({:put_invalid_recipient, recipient}, _from, state) do
    %{invalid: invalid} = state

    invalid = MapSet.put(invalid, recipient)

    {:reply, :ok, Map.put(state, :invalid, invalid)}
  end

  @impl GenServer
  def handle_call({:send_code, recipient, code}, _from, state) do
    %{codes: codes} = state

    codes = Map.put(codes, recipient, code)

    {:reply, :ok, Map.put(state, :codes, codes)}
  end

  @impl GenServer
  def handle_call({:validate_recipient, recipient}, _from, state) do
    %{invalid: invalid} = state

    if MapSet.member?(invalid, recipient) do
      {:reply, {:error, :recipient_blocked}, state}
    else
      {:reply, {:ok, recipient}, state}
    end
  end
end
