defmodule SimpleWeb.UserController do
  use SimpleWeb, :controller

  alias Simple.Accounts
  alias Simple.{Policy}
  alias Simple.Accounts.User

  plug SimpleWeb.Plug.DataToAttributes

  import SimpleWeb.RateLimit
  plug :rate_limit_authentication

  action_fallback SimpleWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, SimpleWeb.UserView, "index.json", %{data: users})
  end

  @spec create(Plug.Conn.t, map) :: Conn.t
  def create(conn, %{"guest" => _guest} = user_params) do
    with {:ok, %User{} = user} <- Accounts.create_guest_user(user_params) do
      create_render(conn, user)
    end
  end
  def create(conn, %{} = user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      create_render(conn, user)
    end
  end

  defp create_render(conn, user) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", user_path(conn, :show, user))
    |> render(SimpleWeb.UserView, "show.json", %{data: user})
  end

  @spec show(Plug.Conn.t, map) :: Conn.t
  def show(conn, %{"id" => id}) do
    with %User{} = _current_user <- conn |> Simple.Guardian.Plug.current_resource,
        %User{} = user <- Accounts.get_user!(id)
    do
      conn |> render("show.json", %{data: user})
    end
  end

  @spec update(Plug.Conn.t, map) :: Conn.t
  def update(conn, %{"id" => id, "guest" => _guest} = user_params) do
    with %User{} = user <- Accounts.get_user!(id),
        %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:update, user),
        {:ok, %User{} = updated_user} <- user |> Accounts.update_guest_user(user_params)
      do
        conn |> render("show.json", %{data: updated_user})
    end
  end
  def update(%Conn{} = conn, %{"id" => id} = user_params) do
    with %User{} = user <- Accounts.get_user!(id),
        %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:update, user),
        {:ok, %User{} = updated_user} <- user |> Accounts.update_user(user_params)
      do
        conn |> render("show.json", %{data: updated_user})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:delete, user),
        {:ok, %User{}} <- Accounts.delete_user(user)
      do
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
