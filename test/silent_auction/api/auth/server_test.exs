defmodule SilentAuction.Api.Auth.ServerTest do
  alias SilentAuction.DB.Repo
  alias SilentAuction.Api.Auth.Server
  alias SilentAuction.Api.Auth.Sender

  alias SilentAuction.DB.Schema.Colour

  use SilentAuction.DBCase

  setup do
    sender = start_supervised!({Sender, sender: Sender.MapSender})
    server = start_supervised!({Server, sender: sender})

    colour = %Colour{}
    red = %{name: "red", hex_code: "#ab1717"}
    changeset = Colour.changeset(colour, red)

    {:ok, _} = Repo.insert(changeset)

    green = %{name: "green", hex_code: "#17ab17"}
    changeset = Colour.changeset(colour, green)

    {:ok, _} = Repo.insert(changeset)

    blue = %{name: "blue", hex_code: "#1717ab"}
    changeset = Colour.changeset(colour, blue)

    {:ok, _} = Repo.insert(changeset)

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

    assert {:error, :invalid_challenge_id} = Server.verify(server, UUID.uuid4(:slug), "XXXXXX")
    assert {:error, :auth_not_started} = Server.verify(server, "a/b", "XXXXXX")
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
