defmodule SimpleWeb.ConversationController do
  use SimpleWeb, :controller

  alias Simple.Accounts.User
  alias Simple.{Messages, Policy}
  alias Simple.Messages.Conversation

  action_fallback SimpleWeb.FallbackController
  plug SimpleWeb.Plug.DataToAttributes

  @spec index(Conn.t, map) :: Conn.t
  def index(conn, params) do
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
      conversations <- Conversation |> Policy.scope(current_user) |> Messages.list_conversations(params) |> preload() do
      conn |> render("index.json", %{data: conversations})
    end
  end

  @spec create(Conn.t, map) :: Conn.t
  def create(conn, params) do
    with %User{} = _current_user <- conn |> Simple.Guardian.Plug.current_resource,
         {:ok, %Conversation{} = conversation} <- Messages.create_conversation(params)
      do
        conn
        |> put_status(:created)
        |> put_resp_header("location", conversation_path(conn, :show, conversation))
        |> render("show.json", %{data: conversation})
    end
  end

  @spec show(Conn.t, map) :: Conn.t
  def show(conn, %{"id" => id}) do
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        %Conversation{} = conversation <- Messages.get_conversation(id) |> preload(),
        {:ok, :authorized} <- current_user |> Policy.authorize(:show, conversation, %{}) 
      do
        conn |> render("show.json", %{data: conversation})
    end
  end

  @spec update(Conn.t, map) :: Conn.t
  def update(%Conn{} = conn, %{"id" => id} = params) do
    with %Conversation{} = conversation <- Messages.get_conversation(id) |> preload(),
        %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:update, conversation),
        {:ok, %Conversation{} = updated_conversation} <- conversation |> Messages.update_conversation(params)
      do
        conn |> render("show.json", %{data: updated_conversation})
    end
  end

  def delete(conn, %{"id" => id}) do
    conversation = Messages.get_conversation(id)
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:delete, conversation),
        {:ok, %Conversation{}} <- Messages.delete_conversation(conversation)
      do
        send_resp(conn, :no_content, "")
    end
  end

  @preloads [:user, conversation_parts: [:user]]

  def preload(data) do
    Repo.preload(data, @preloads)
  end
end
