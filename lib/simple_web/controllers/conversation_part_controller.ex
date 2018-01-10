defmodule SimpleWeb.ConversationPartController do
  @moduledoc false
  use SimpleWeb, :controller

  alias Simple.Accounts.User
  alias Simple.{Messages, Policy}
  alias Simple.Messages.{
    ConversationPart
  }
  alias Simple.Accounts.User

  action_fallback SimpleWeb.FallbackController
  plug SimpleWeb.Plug.DataToAttributes

  @spec index(Conn.t, map) :: Conn.t
  def index(%Conn{} = conn, _params) do
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
         conversation_parts <- ConversationPart |> Policy.scope(current_user) |> Messages.list_conversation_parts() |> preload() do
      conn |> render("index.json", %{data: conversation_parts})
    end
  end

  @spec create(Plug.Conn.t, map) :: Conn.t
  def create(%Conn{} = conn, %{} = params) do
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
         {:ok, :authorized} <- current_user |> Policy.authorize(:create, %ConversationPart{}, params),
         {:ok, %ConversationPart{} = conversation_part} <- Messages.create_conversation_part(params),
         conversation_part <- conversation_part |> preload()
    do
      SimpleWeb.ConversationChannel.broadcast_new_conversation_part(conversation_part)
      conn |> put_status(:created) |> render("show.json", %{data: conversation_part})
    end
  end

  @spec show(Conn.t, map) :: Conn.t
  def show(%Conn{} = conn, %{"id" => id}) do
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
      %ConversationPart{} = conversation_part <- Messages.get_conversation_part(id) |> preload(),
      {:ok, :authorized} <- current_user |> Policy.authorize(:show, conversation_part, %{}) do
      conn |> render("show.json", %{data: conversation_part})
    end
  end

  @spec delete(Conn.t, map) :: Conn.t
  def delete(conn, %{"id" => id}) do
    conversation_part = Messages.get_conversation_part(id)
    with %User{} = current_user <- conn |> Simple.Guardian.Plug.current_resource,
        {:ok, :authorized} <- current_user |> Policy.authorize(:delete, conversation_part),
        {:ok, %ConversationPart{}} <- Messages.delete_conversation_part(conversation_part)
      do
        send_resp(conn, :no_content, "")
    end
  end

  @preloads [:user]

  def preload(data) do
    Repo.preload(data, @preloads)
  end
end
