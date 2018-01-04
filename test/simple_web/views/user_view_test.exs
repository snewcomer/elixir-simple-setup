defmodule SimpleWeb.UserViewTest do
  use SimpleWeb.ViewCase

  alias SimpleWeb.UserView
  alias Plug.Conn

  test "renders all attributes and relationships properly" do
    user = insert(:user, first_name: "First", last_name: "Last")

    # host = Application.get_env(:simple, :asset_host)

    rendered_json = render(UserView, "show.json", %{data: user, conn: %Conn{}, params: user.id})

    expected_json = %{
      :data => %{
        id: user.id,
        type: "users",
        attributes: %{
          "email" => user.email,
          "first-name" => user.first_name,
          "inserted-at" => user.inserted_at,
          "last-name" => user.last_name,
          # "photo-large-url" => "#{host}/icons/user_default_large_blue.png",
          # "photo-thumb-url" => "#{host}/icons/user_default_thumb_light_blue.png",
          "username" => user.username,
          "updated-at" => user.updated_at
        },
        relationships: %{}
      },
      included: []
    }

    assert rendered_json == expected_json
  end
end
