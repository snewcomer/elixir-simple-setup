defmodule SimpleWeb.UserControllerTest do

  use SimpleWeb.ApiCase, resource_name: :user

  alias Simple.Accounts
  alias Simple.Accounts.User

  @create_attrs %{email: "some@email.com", first_name: "some first_name", last_name: "some last_name", 
    password: "some password", username: "some username", cloudinary_public_id: "123"}
  @guest_attrs %{username: "some username", guest: true}
  @update_guest_attrs %{email: "some_guest@email.com", first_name: "some first_name", last_name: "some last_name",
    password: "some password", username: "some username", cloudinary_public_id: "123", guest: true}
  @update_attrs %{email: "some@updateemail.com", first_name: "some updated first_name", last_name: "some updated last_name", 
    username: "some updated username", cloudinary_public_id: "456", admin: "true"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :authenticated
    test "lists all users", %{conn: conn, current_user: user} do
      conn
      |> request_index
      |> json_response(200)
      |> assert_ids_from_response([user.id])
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      data = 
        conn
        |> request_create(@create_attrs)
        |> json_response(201)
        |> Map.get("data")
        |> Map.get("attributes")

      assert data["admin"] == nil
      assert data["email"] == "some@email.com"
      assert data["first-name"] == "some first_name"
      assert data["last-name"] == "some last_name"
      assert data["username"] == "some username"
      assert data["cloudinary-public-id"] == "123"
    end

    test "renders guest user when data is valid", %{conn: conn} do
      path = conn |> user_path(:create)

      data = 
        conn
        |> post(path <> "?guest=true", @guest_attrs)
        |> json_response(201)
        |> Map.get("data")
        |> Map.get("attributes")

      assert data["username"] == "some username"
      assert data["guest"] == true
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn
      |> request_create(@invalid_attrs)
      |> json_response(422)
    end

    @tag :authenticated
    test "renders 201 when authenticated", %{conn: conn} do
      assert conn |> request_create(@create_attrs) |> json_response(201)
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :authenticated
    test "renders user when data is valid", %{conn: conn, current_user: %User{id: _id} = user} do
      data =
        conn
        |> request_update(user.id, @update_attrs)
        |> json_response(200)
        |> Map.get("data")
        |> Map.get("attributes")

      assert data["email"] == "some@updateemail.com"
      assert data["first-name"] == "some updated first_name"
      assert data["last-name"] == "some updated last_name"
      assert data["username"] == "some updated username"
      assert data["cloudinary-public-id"] == "456"
      assert data["photo-large-url"]
      assert data["photo-thumb-url"]
    end

    @tag :wip
    @tag :authenticated
    test "renders user when guest data is valid", %{conn: conn, current_user: %User{id: _id} = user} do
      path = conn |> user_path(:update, user.id)

      data = 
        conn
        |> put(path <> "?guest=true", @update_guest_attrs)
        |> json_response(200)
        |> Map.get("data")
        |> Map.get("attributes")

      assert data["admin"] == nil
      assert data["email"] == "some_guest@email.com"
      assert data["first-name"] == "some first_name"
      assert data["last-name"] == "some last_name"
      assert data["username"] == "some username"
      assert data["cloudinary-public-id"] == "123"
      assert data["photo-large-url"]
      assert data["photo-thumb-url"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, current_user: user} do
      conn
      |> request_update(user.id, @invalid_attrs)
      |> json_response(422)
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conn |> request_update |> json_response(401)
    end

    @tag :authenticated
    test "does not update resource and renders 403 when not authorized", %{conn: conn} do
      user = insert(:user, admin: false)
      assert conn |> request_update(user.id, @update_attrs) |> json_response(403)
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag :authenticated
    test "deletes chosen user", %{conn: conn, current_user: user} do
      conn 
      |> request_delete(user.id)
      |> response(204)
    end

    test "renders 401 when not authenticated", %{conn: conn, user: user} do
      conn 
      |> request_delete(user.id)
      |> response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn, user: user} do
      conn 
      |> request_delete(user.id)
      |> response(403)
    end
  end

  describe "email_available" do
    test "returns valid and available when email is valid and available", %{conn: conn} do
      resp = get conn, user_path(conn, :email_available, %{email: "available@mail.com"})
      json = json_response(resp, 200)
      assert json["available"]
      assert json["valid"]
    end

    test "returns valid but inavailable when email is valid but taken", %{conn: conn} do
      insert(:user, email: "used@mail.com")
      resp = get conn, user_path(conn, :email_available, %{email: "used@mail.com"})
      json = json_response(resp, 200)
      refute json["available"]
      assert json["valid"]
    end

    test "returns as available but invalid when email is invalid", %{conn: conn} do
      resp = get conn, user_path(conn, :email_available, %{email: "not_an_email"})
      json = json_response(resp, 200)
      assert json["available"]
      refute json["valid"]
    end
  end

  describe "username_available" do
    test "returns as valid and available when username is valid and available", %{conn: conn} do
      resp = get conn, user_path(conn, :username_available, %{username: "available"})
      json = json_response(resp, 200)
      assert json["available"]
      assert json["valid"]
    end

    test "returns as valid, but inavailable when username is valid but taken", %{conn: conn} do
      insert(:user, username: "used")
      resp = get conn, user_path(conn, :username_available, %{username: "used"})
      json = json_response(resp, 200)
      refute json["available"]
      assert json["valid"]
    end

    test "returns available but invalid when username is invalid", %{conn: conn} do
      resp = get conn, user_path(conn, :username_available, %{username: ""})
      json = json_response(resp, 200)
      assert json["available"]
      refute json["valid"]
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
