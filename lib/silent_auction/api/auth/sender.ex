defmodule SilentAuction.Api.Auth.Sender do
  @moduledoc """
  ## Sender

  Given a recipient and a verification code, send the code to the recipient.
  """

  def start_link(arg) do
    sender = Keyword.fetch!(arg, :sender)
    name = Keyword.get(arg, :name)

    GenServer.start_link(sender, arg, name: name)
  end

  def child_spec(arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg]}
    }
  end

  def validate_recipient(pid, recipient) do
    GenServer.call(pid, {:validate_recipient, recipient})
  end

  def send_code(pid, recipient, code) do
    GenServer.call(pid, {:send_code, recipient, code})
  end
end
