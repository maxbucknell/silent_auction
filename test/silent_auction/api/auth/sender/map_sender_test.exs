defmodule SilentAuction.Api.Auth.Sender.MapSenderTest do
  use ExUnit.Case

  alias SilentAuction.Api.Auth.Sender
  alias SilentAuction.Api.Auth.Sender.MapSender

  setup do
    {:ok, sender} = GenServer.start_link(MapSender, nil)

    %{sender: sender}
  end

  test "validates correct code", %{sender: sender} do
    recipient = "Harold Holt"
    code = "451669"

    Sender.send_code(sender, recipient, code)

    assert {:ok, ^code} = MapSender.lookup(sender, recipient)
  end

  test "invalid credentials", %{sender: sender} do
    recipient = "Harold Holt"

    MapSender.put_invalid_recipient(sender, recipient)

    assert {:error, :recipient_blocked} = Sender.validate_recipient(sender, recipient)
  end
end
