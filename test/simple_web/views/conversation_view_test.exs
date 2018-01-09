defmodule SimpleWeb.ConversationViewTest do
  use SimpleWeb.ViewCase

  alias Plug.Conn

  alias Simple.Repo

  test "renders all attributes and relationships properly" do
    user = insert(:user, default_color: "blue")
    conversation = insert(:conversation, user: user)
    conversation_part = insert(:conversation_part, conversation: conversation, user: user)

    rendered_json =
      SimpleWeb.ConversationView
      |> render(
        "show.json",
        %{data: conversation |> Repo.preload([:user, conversation_parts: [:user]]), conn: %Conn{}, params: conversation.id}
      )

    host = Application.get_env(:simple, :asset_host)

    expected_json = %{
      :data => %{
        id: conversation.id,
        type: "conversations",
        attributes: %{
          "body" => conversation.body,
          "is-locked" => conversation.is_locked,
          "receive-notifications" => conversation.receive_notifications,
          "read-at" => conversation.read_at,
          "status" => conversation.status,
          "title" => conversation.title,
          "inserted-at" => conversation.inserted_at,
          "updated-at" => conversation.updated_at
        },
        relationships: %{
          "conversation-parts" => %{
            :data => [
              %{
                id: conversation_part.id,
                type: "conversation-parts"
              }
            ]
          },
          "user" => %{
            :data => %{
              id: conversation.user_id,
              type: "users"
            }
          }
        },
      },
      included: [
        %{
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
        },
        %{
          attributes: %{
            "body" => conversation_part.body,
            "read-at" => conversation_part.read_at,
            "inserted-at" => conversation_part.inserted_at,
            "updated-at" => conversation_part.updated_at
          },
          id: conversation_part.id,
          type: "conversation-parts",
          relationships: %{
            "user" => %{
              data: %{
                id: user.id,
                type: "users"
              }
            }
          }
        }
    ]
    }

    assert rendered_json == expected_json
  end
end
