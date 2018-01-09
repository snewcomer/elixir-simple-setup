defmodule SimpleWeb.ConversationPartView do
  use SimpleWeb, :view

  use JSONAPI.View, type: "conversation-parts"

  def fields do
    [:body, :read_at, :inserted_at, :updated_at]
  end

  def relationships do
    [user: {SimpleWeb.UserView, :include}]
  end
end
