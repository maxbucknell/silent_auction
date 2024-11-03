defmodule SilentAuction.Api.Auth.Guardian.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _}, _opts) do
    {status, error} =
      case type do
        :unauthorized -> {401, :unauthorized}
        :invalid_token -> {401, :unauthorized}
        :already_authenticated -> {400, :already_authenticated}
        :no_resource_found -> {401, :unauthorized}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(%{error: error}))
  end
end
