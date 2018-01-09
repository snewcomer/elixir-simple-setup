defmodule SimpleWeb.ConversationView do
  use SimpleWeb, :view

  use JSONAPI.View, type: "conversations"

  def fields do
    [:body, :title, :is_locked, :receive_notifications, :read_at, :status, :inserted_at, :updated_at]
  end

  def relationships do
    [user: {SimpleWeb.UserView, :include}, conversation_parts: {SimpleWeb.ConversationPartView, :include}]
  end

  # def render("index.json", %{users: users}) do
  #   %{data: render_many(users, UserView, "user.json")}
  # end

  # def render("show.json", %{user: user}) do
  #   %{data: render_one(user, UserView, "user.json")}
  # end

  # def render("user.json", %{user: user}) do
  #   %{id: user.id,
  #     username: user.username,
  #     password: user.password,
  #     encrypted_password: user.encrypted_password,
  #     email: user.email,
  #     first_name: user.first_name,
  #     last_name: user.last_name}
  # end
end
