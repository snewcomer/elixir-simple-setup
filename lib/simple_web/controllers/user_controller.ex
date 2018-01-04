defmodule SimpleWeb.UserController do
  use SimpleWeb, :controller

  alias Simple.Accounts
  alias Simple.Accounts.User

  plug SimpleWeb.Plug.DataToAttributes

  action_fallback SimpleWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, SimpleWeb.UserView, "index.json", %{data: users})
  end

  def create(conn, %{} = user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render(SimpleWeb.UserView, "show.json", %{data: user})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, SimpleWeb.UserView, "show.json", %{data: user})
  end

  @spec update(Plug.Conn.t, map) :: Conn.t
  def update(%Conn{} = conn, %{"id" => id} = user_params) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, SimpleWeb.UserView, "show.json", %{data: user})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @spec email_available(Conn.t, map) :: Conn.t
  def email_available(%Conn{} = conn, %{"email" => email}) do
    hash = Accounts.check_email_availability(email)
    conn |> json(hash)
  end

  @spec username_available(Conn.t, map) :: Conn.t
  def username_available(%Conn{} = conn, %{"username" => username}) do
    hash = Accounts.check_username_availability(username)
    conn |> json(hash)
  end
end
