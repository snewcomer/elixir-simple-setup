defmodule SimpleWeb.ConversationControllerTest do
  use SimpleWeb.ApiCase, resource_name: :conversation

  @valid_attrs %{body: "some body", is_locked: true, read_at: Timex.now(), receive_notifications: true, status: "open", title: "some title"}
  @invalid_attrs %{body: nil, title: nil}

  describe "index" do
    @tag :authenticated
    test "lists all entries user is authorized to view", %{conn: conn, current_user: user} do
      _conversation = insert(:conversation, participants: [build(:user)])
      conversation_by_user = insert(:conversation, user: user)
      _other_conversation = insert(:conversation)

      conn
      |> request_index
      |> json_response(200)
      |> assert_ids_from_response([conversation_by_user.id])
    end

    @tag authenticated: :admin
    test "lists all entries if user is admin", %{conn: conn} do
      [conversation_1, conversation_2] = insert_pair(:conversation)

      conn
      |> request_index
      |> json_response(200)
      |> assert_ids_from_response([conversation_1.id, conversation_2.id])
    end

    @tag authenticated: :admin
    test "lists all entries by query title", %{conn: conn} do
      insert_pair(:conversation, title: "foo")
      conversation_other = insert(:conversation, title: "wat")

      conn
      |> get("conversations?query=wat")
      |> json_response(200)
      |> assert_ids_from_response([conversation_other.id])
    end

    @tag authenticated: :admin
    test "lists all entries by query body", %{conn: conn} do
      insert_pair(:conversation, body: "foo")
      conversation_other = insert(:conversation, body: "wat")
      conversation_another = insert(:conversation, title: "wat")

      conn
      |> get("conversations?query=wat")
      |> json_response(200)
      |> assert_ids_from_response([conversation_other.id, conversation_another.id])
    end

    @tag authenticated: :admin
    test "lists all entries by status", %{conn: conn} do
      insert_pair(:conversation, status: "closed")
      user = insert(:user)
      conversation_other = insert(:conversation, user: user, status: "open")

      conn
      |> get("conversations?status=open")
      |> json_response(200)
      |> assert_ids_from_response([conversation_other.id])
    end
  end

  describe "show" do
    @tag :authenticated
    test "shows chosen resource", %{conn: conn, current_user: user} do
      conversation = insert(:conversation, user: user)

      conn
      |> request_show(conversation)
      |> json_response(200)
      |> assert_id_from_response(conversation.id)
    end

    test "renders 401 when unauthenticated", %{conn: conn} do
      conversation = insert(:conversation)
      assert conn |> request_show(conversation) |> json_response(401)
    end

    @tag :authenticated
    test "renders 403 when unauthorized", %{conn: conn} do
      conversation = insert(:conversation)
      assert conn |> request_show(conversation) |> json_response(403)
    end
  end

  describe "create" do
    @tag :authenticated
    test "renders user when data is valid", %{conn: conn, current_user: user} do
      attrs = Map.put_new(@valid_attrs, :user_id, user.id)
      data = 
        conn
        |> request_create(attrs)
        |> json_response(201)
        |> Map.get("data")
        |> Map.get("attributes")

      assert data["body"] == "some body"
      assert data["title"] == "some title"
      assert data["status"] == "open"
    end

    test "renders 401 when unauthenticated", %{conn: conn} do
      assert conn |> request_create() |> json_response(401)
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn
      |> request_create(@invalid_attrs)
      |> json_response(422)
    end
  end

  describe "update" do
    @tag authenticated: :admin
    test "updates and renders chosen resource when data is valid", %{conn: conn, current_user: user} do
      conversation = insert(:conversation, user: user)

      data = 
        conn 
          |> request_update(conversation.id, %{status: "closed"}) 
          |> json_response(200)
          |> Map.get("data")
      
      assert data["attributes"]["status"] == "closed"
    end

    @tag authenticated: :admin
    test "renders 422 when data is invalid", %{conn: conn, current_user: current_user} do
      conversation = insert(:conversation, user: current_user)
      assert conn |> request_update(conversation.id, %{status: "wat"}) |> json_response(422)
    end

    test "renders 401 when unauthenticated", %{conn: conn} do
      assert conn |> request_update |> json_response(401)
    end

    @tag :authenticated
    test "does not update resource and renders 403 when not authorized", %{conn: conn} do
      assert conn |> request_update() |> json_response(403)
    end
  end

  describe "delete" do

    @tag :authenticated
    test "deletes conversation", %{conn: conn, current_user: user} do
      conversation = insert(:conversation, user: user)

      conn 
      |> request_delete(conversation.id)
      |> response(204)
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      conversation = insert(:conversation)

      conn 
      |> request_delete(conversation.id)
      |> response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn} do
      conversation = insert(:conversation)

      conn 
      |> request_delete(conversation.id)
      |> response(403)
    end
  end

end
