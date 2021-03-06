defmodule SimpleWeb.ConversationPartViewTest do
  use SimpleWeb.ViewCase

  alias Plug.Conn

  @tag :wip
  test "renders all attributes and relationships properly" do
    user = build(:user, default_color: "blue")
    conversation_part = build(:conversation_part, user: user)

    rendered_json =
      SimpleWeb.ConversationPartView
      |> render(
        "show.json",
        %{data: conversation_part, conn: %Conn{}, params: conversation_part.id}
      )

    host = Application.get_env(:simple, :asset_host)

    expected_json = %{
      :data => %{
        id: conversation_part.id,
        type: "conversation-parts",
        attributes: %{
          "body" => conversation_part.body,
          "read-at" => conversation_part.read_at,
          "inserted-at" => conversation_part.inserted_at,
          "updated-at" => conversation_part.updated_at
        },
        relationships: %{
          "user" => %{
            :data => %{
              id: conversation_part.user.id,
              type: "users"
            }
          }
        },
      },
      included: [%{
        attributes: %{
          "cloudinary-public-id" => user.cloudinary_public_id,
          "description" => user.description,
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
        id: user.id,
        type: "users",
        relationships: %{}
      }]
    }

    assert rendered_json == expected_json
  end
end
