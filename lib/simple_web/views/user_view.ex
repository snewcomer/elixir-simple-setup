defmodule SimpleWeb.UserView do
  use SimpleWeb, :view
  use JSONAPI.View, type: "users"

  alias Simple.Presenters.ImagePresenter

  def fields do
    [:cloudinary_public_id, :email, :first_name, :guest, :last_name, :username, :photo_large_url, :photo_thumb_url, :inserted_at, :updated_at]
  end

  def photo_large_url(user, _conn), do: ImagePresenter.large(user)

  def photo_thumb_url(user, _conn), do: ImagePresenter.thumbnail(user)

  def email(user, %Plug.Conn{assigns: %{current_user: current_user}}) do
    if user.id == current_user.id, do: user.email, else: ""
  end
  def email(_user, _conn), do: ""
end
