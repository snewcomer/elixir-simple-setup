defmodule SimpleWeb.UserViewTest do
  use SimpleWeb.ViewCase

  alias SimpleWeb.UserView
  alias Phoenix.ConnTest
  alias Plug.Conn

  test "renders all attributes and relationships properly" do
    user = insert(:user, first_name: "First", last_name: "Last", default_color: "blue")

    host = Application.get_env(:simple, :asset_host)

    rendered_json = render(UserView, "show.json", %{data: user, conn: %Conn{}, params: user.id})

    expected_json = %{
      :data => %{
        id: user.id,
        type: "users",
        attributes: %{
          "cloudinary-public-id" => user.cloudinary_public_id,
          "email" => "",
          "first-name" => user.first_name,
          "guest" => user.guest,
          "inserted-at" => user.inserted_at,
          "last-name" => user.last_name,
          "photo-large-url" => "#{host}/icons/user_default_large_blue.png",
          "photo-thumb-url" => "#{host}/icons/user_default_thumb_blue.png",
          "username" => user.username,
          "updated-at" => user.updated_at
        },
        relationships: %{}
      },
      included: []
    }

    assert rendered_json == expected_json
  end

  test "renders email when user is the authenticated user" do
    user = insert(:user)

    conn =
      ConnTest.build_conn()
      |> Conn.assign(:current_user, user)

    rendered_json = render(UserView, "show.json", %{data: user, conn: conn, params: user.id})
    assert rendered_json.data.attributes["email"] == user.email
  end
end
