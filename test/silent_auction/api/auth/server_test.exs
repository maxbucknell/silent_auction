defmodule SilentAuction.Api.Auth.ServerTest do
  alias SilentAuction.Api.Auth.Server
  alias SilentAuction.Api.Auth.Sender

  use ExUnit.Case

  setup do
    sender = start_supervised!({Sender, sender: Sender.MapSender})
    server = start_supervised!({Server, sender: sender})

    %{server: server, sender: sender}
  end

  test "can communicate with sender", state do
    %{server: server, sender: sender} = state

    recipient = {:phone, "61491570006"}

    assert {:ok, challenge_id} = Server.challenge(server, recipient)

    assert {:ok, code} = Sender.MapSender.lookup(sender, recipient)

    assert {:ok, _} = Server.verify(server, challenge_id, code)
  end

  test "blocked recipients cannot pass", state do
    %{server: server, sender: sender} = state

    recipient = {:phone, "61491570006"}

    Sender.MapSender.put_invalid_recipient(sender, recipient)

    assert {:error, _} = Server.challenge(server, recipient)
  end

  test "invalid code", state do
    %{server: server} = state

    recipient = {:phone, "61491570006"}

    {:ok, challenge_id} = Server.challenge(server, recipient)

    assert {:error, :invalid_code} = Server.verify(server, challenge_id, "XXXXXX")
  end

  test "early verification", state do
    %{server: server} = state

    assert {:error, :auth_not_started} = Server.verify(server, UUID.uuid4(:raw), "XXXXXX")
  end

  test "old code", state do
    %{server: server, sender: sender} = state

    recipient = {:phone, "61491570006"}

    {:ok, challenge_id_old} = Server.challenge(server, recipient)

    {:ok, code} = Sender.MapSender.lookup(sender, recipient)

    {:ok, challenge_id} = Server.challenge(server, recipient)

    assert {:error, :invalid_code} = Server.verify(server, challenge_id_old, code)

    assert {:error, :invalid_code} = Server.verify(server, challenge_id, code)
  end
end
