defmodule Simple.AuthenticationTestHelpers do
  use Phoenix.ConnTest
  import Simple.Factories

  def authenticate(conn) do
    user = insert(:user)

    conn
    |> authenticate(user)
  end

  def authenticate(conn, user) do
    {:ok, token, _} = user |> Simple.Guardian.encode_and_sign()

    conn
    |> put_req_header("authorization", "Bearer #{token}")
  end
end
