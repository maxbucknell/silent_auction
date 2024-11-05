defmodule SilentAuction.Api.Auth do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  post "/challenge" do
    alias SilentAuction.Api.Auth.Server

    {status, resp} =
      with {:ok, recipient} <- parse_recipient(conn.body_params),
           {:ok, challenge_id} <- Server.challenge(Server, recipient) do
        {201, %{"challenge_id" => challenge_id}}
      else
        {:error, :unknown_error} -> {500, %{}}
        {:error, reason} -> {400, %{"error" => reason}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(resp))
  end

  defp parse_recipient(params) do
    IO.inspect(params)

    case params do
      %{"phone" => phone} -> {:ok, {:phone, phone}}
      _ -> {:error, :identity_not_recognised}
    end
  end

  post "/verify" do
    alias SilentAuction.Api.Auth.Server

    {status, resp} =
      with {:ok, {challenge_id, code}} <- parse_verification(conn.body_params),
           {:ok, token} <- Server.verify(Server, challenge_id, code) do
        {201, %{"token" => token}}
      else
        {:error, :unknown_error} -> {500, %{}}
        {:error, reason} -> {400, %{"error" => reason}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(resp))
  end

  def parse_verification(params) do
    case params do
      %{"code" => code, "challenge_id" => challenge_id} -> {:ok, {challenge_id, code}}
      _ -> {:error, :invalid_verification}
    end
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
