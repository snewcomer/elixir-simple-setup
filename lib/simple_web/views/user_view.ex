defmodule SimpleWeb.UserView do
  use SimpleWeb, :view
  use JSONAPI.View, type: "users"

  alias Simple.Presenters.ImagePresenter

  def fields do
    [:email, :first_name, :last_name, :username, :photo_large_url, :photo_thumb_url, :inserted_at, :updated_at]
  end

  def photo_large_url(user, _conn), do: ImagePresenter.large(user)

  def photo_thumb_url(user, _conn), do: ImagePresenter.thumbnail(user)
end
