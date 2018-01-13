defmodule Simple.AccountsTest do
  use Simple.DataCase

  alias Simple.Accounts

  describe "users" do
    alias Simple.Accounts.User

    @valid_attrs %{email: "some@email.com", first_name: "some first_name", last_name: "some last_name", 
      password: "some password", username: "some username"}
    @guest_attrs %{username: "some username", guest: true}
    @update_guest_attrs %{email: "some_guest@email.com", first_name: "some first_name", last_name: "some last_name", 
      password: "some password", username: "some username"}
    @update_attrs %{email: "some_update@email.com", first_name: "some updated first_name", last_name: "some updated last_name", 
      username: "some updated username", cloudinary_public_id: "123"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert Accounts.list_users() |> Enum.count == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      ret_user = Accounts.get_user!(user.id)
      assert user.email == ret_user.email
      assert user.first_name == ret_user.first_name
      assert user.last_name == ret_user.last_name
      assert user.username == ret_user.username
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.admin == nil
      assert user.email == "some@email.com"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.encrypted_password
      assert user.username == "some username"
      assert user.default_color == "blue"
      assert user.cloudinary_public_id == nil
    end

    test "create_guest_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_guest_user(@guest_attrs)
      refute user.encrypted_password
      refute user.email
      refute user.first_name
      refute user.last_name
      assert user.username == "some username"
      assert user.default_color == "blue"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_guest_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_guest_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some_update@email.com"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.username == "some updated username"
      assert user.cloudinary_public_id == "123"
    end

    test "update_guest_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_guest_user(user, @update_guest_attrs)
      assert %User{} = user
      assert user.admin == nil
      assert user.email == "some_guest@email.com"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.encrypted_password
      assert user.username == "some username"
      assert user.default_color == "blue"
      assert user.cloudinary_public_id == nil
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end

    test "update_guest_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_guest_user(user, @invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
