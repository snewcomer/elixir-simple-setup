defmodule SimpleWeb.TokenController do
  @moduledoc false
  use SimpleWeb, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Simple.Helpers.Query, only: [login_filter: 2]
  alias Simple.Accounts.User

  def create(conn, params = %{"username" => _, "password" => _}) do
    case login_by_username_and_pass(params) do
      {:ok, user} ->
        {:ok, token, _claims} = user |> Simple.Guardian.encode_and_sign()

        conn
        |> Plug.Conn.assign(:current_user, user)
        |> put_status(:created)
        |> render("show.json", token: token, user_id: user.id)

      {:error, reason} -> handle_unauthenticated(conn, reason)
    end
  end
  def create(conn, %{"username" => ""}) do
    handle_unauthenticated(conn, "Please enter your username and password.")
  end
  def create(conn, %{"username" => _username}) do
    handle_unauthenticated(conn, "Please enter your password.")
  end

  def refresh(conn, %{"token" => current_token}) do
    with {:ok, _claims} <- Simple.Guardian.decode_and_verify(current_token),
         {:ok, _, {new_token, new_claims}} <- Simple.Guardian.refresh(current_token),
         {:ok, user} <- Simple.Guardian.resource_from_claims(new_claims) do
            conn
            |> Plug.Conn.assign(:current_user, user)
            |> put_status(:created)
            |> render("show.json", token: new_token, user_id: user.id)
    else
      {:error, reason} -> handle_unauthenticated(conn, reason)
    end
  end

  defp handle_unauthenticated(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("401.json", message: reason)
  end

  defp login_by_username_and_pass(%{"username" => username, "password" => password}) do
    user = User |> login_filter(username)
    cond do
      user && checkpw(password, user.encrypted_password) ->
        {:ok, user}
      user ->
        {:error, "Your password doesn't match the username #{username}."}
      true ->
        dummy_checkpw()
        {:error, "We couldn't find a user with the username #{username}."}
    end
  end
end
