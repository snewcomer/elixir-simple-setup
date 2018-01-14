defmodule SimpleWeb.ConversationViewTest do
  use SimpleWeb.ViewCase

  alias Plug.Conn

  alias Simple.Repo

  test "renders all attributes and relationships properly" do
    conversation = build(:conversation_with_parts)
    user = conversation.user
    conversation_part = conversation.conversation_parts |> Enum.at(0)
    part_user = conversation_part.user

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
          "notified" => conversation.notified,
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
              id: conversation.user.id,
              type: "users"
            }
          }
        },
      },
      included: [
        %{
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
        },
        %{
          attributes: %{
            "cloudinary-public-id" => part_user.cloudinary_public_id,
            "description" => part_user.description,
            "email" => "",
            "first-name" => part_user.first_name,
            "guest" => part_user.guest,
            "inserted-at" => part_user.inserted_at,
            "last-name" => part_user.last_name,
            "photo-large-url" => "#{host}/icons/user_default_large_blue.png",
            "photo-thumb-url" => "#{host}/icons/user_default_thumb_blue.png",
            "username" => part_user.username,
            "updated-at" => part_user.updated_at
          },
          id: part_user.id,
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
                id: part_user.id,
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
