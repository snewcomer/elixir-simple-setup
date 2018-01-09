defmodule SimpleWeb.ConversationPartViewTest do
  use SimpleWeb.ViewCase

  alias Plug.Conn

  test "renders all attributes and relationships properly" do
    user = insert(:user, default_color: "blue")
    conversation_part = insert(:conversation_part, user: user)

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
              id: conversation_part.user_id,
              type: "users"
            }
          }
        },
      },
      included: [%{
        attributes: %{
          "email" => user.email,
          "first-name" => user.first_name,
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
