defmodule SimpleWeb.ConversationView do
  use SimpleWeb, :view

  use JSONAPI.View, type: "conversations"

  def fields do
    [:body, :title, :is_locked, :notified, :receive_notifications, :read_at, :status, :inserted_at, :updated_at]
  end

  def relationships do
    [user: {SimpleWeb.UserView, :include}, conversation_parts: {SimpleWeb.ConversationPartView, :include}]
  end
end
