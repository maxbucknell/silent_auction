alias SilentAuction.Api.Auth.Sender

defmodule Sender.LogSender do
  @moduledoc """
  Implements Sender by outputting to log
  """

  use GenServer

  require Logger

  @impl GenServer
  def init(arg) do
    level = Keyword.get(arg, :level, :notice)

    {:ok, %{level: level}}
  end

  @impl GenServer
  def handle_call({:validate_recipient, recipient}, _from, state) do
    {:reply, {:ok, recipient}, state}
  end

  @impl GenServer
  def handle_call({:send_code, recipient, code}, _from, state) do
    Logger.log(state.level, "Authentication code for #{recipient}: #{code}.")

    {:reply, :ok, state}
  end
end
