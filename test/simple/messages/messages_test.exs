defmodule Simple.MessagesTest do
  use Simple.DataCase

  alias Simple.Messages

  describe "conversations" do
    alias Simple.Messages.Conversation

    @valid_attrs %{body: "some body", is_locked: true, read_at: Timex.now(), receive_notifications: true, status: "open", title: "some title"}
    @update_attrs %{body: "some updated body", is_locked: false, read_at: Timex.now(), receive_notifications: false, status: "closed", title: "some updated title"}
    @invalid_attrs %{body: nil, is_locked: nil, read_at: nil, receive_notifications: nil, status: nil, title: nil}

    def conversation_fixture(attrs \\ %{}) do
      {:ok, conversation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_conversation()

      conversation
    end

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Messages.list_conversations(Conversation) == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Messages.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      assert {:ok, %Conversation{} = conversation} = Messages.create_conversation(@valid_attrs)
      assert conversation.body == "some body"
      assert conversation.is_locked == true
      assert conversation.read_at
      assert conversation.receive_notifications == true
      assert conversation.status == "open"
      assert conversation.title == "some title"
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      assert {:ok, conversation} = Messages.update_conversation(conversation, @update_attrs)
      assert %Conversation{} = conversation
      assert conversation.body == "some updated body"
      assert conversation.is_locked == false
      assert conversation.read_at
      assert conversation.receive_notifications == false
      assert conversation.status == "closed"
      assert conversation.title == "some updated title"
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_conversation(conversation, @invalid_attrs)
      assert conversation == Messages.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Messages.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Messages.change_conversation(conversation)
    end
  end

  describe "conversation_parts" do
    alias Simple.Messages.ConversationPart

    @valid_attrs %{body: "some body", read_at: "2010-04-17 14:00:00.000000Z"}
    @update_attrs %{body: "some updated body", read_at: "2011-05-18 15:01:01.000000Z"}
    @invalid_attrs %{body: nil, read_at: nil}

    def conversation_part_fixture(attrs \\ %{}) do
      {:ok, conversation_part} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_conversation_part()

      conversation_part
    end

    test "list_conversation_parts/0 returns all conversation_parts" do
      conversation_part = conversation_part_fixture()
      assert Messages.list_conversation_parts() == [conversation_part]
    end

    test "get_conversation_part!/1 returns the conversation_part with given id" do
      conversation_part = conversation_part_fixture()
      assert Messages.get_conversation_part!(conversation_part.id) == conversation_part
    end

    test "create_conversation_part/1 with valid data creates a conversation_part" do
      assert {:ok, %ConversationPart{} = conversation_part} = Messages.create_conversation_part(@valid_attrs)
      assert conversation_part.body == "some body"
      assert conversation_part.read_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_conversation_part/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_conversation_part(@invalid_attrs)
    end

    test "update_conversation_part/2 with valid data updates the conversation_part" do
      conversation_part = conversation_part_fixture()
      assert {:ok, conversation_part} = Messages.update_conversation_part(conversation_part, @update_attrs)
      assert %ConversationPart{} = conversation_part
      assert conversation_part.body == "some updated body"
      assert conversation_part.read_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_conversation_part/2 with invalid data returns error changeset" do
      conversation_part = conversation_part_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_conversation_part(conversation_part, @invalid_attrs)
      assert conversation_part == Messages.get_conversation_part!(conversation_part.id)
    end

    test "delete_conversation_part/1 deletes the conversation_part" do
      conversation_part = conversation_part_fixture()
      assert {:ok, %ConversationPart{}} = Messages.delete_conversation_part(conversation_part)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_conversation_part!(conversation_part.id) end
    end

    test "change_conversation_part/1 returns a conversation_part changeset" do
      conversation_part = conversation_part_fixture()
      assert %Ecto.Changeset{} = Messages.change_conversation_part(conversation_part)
    end
  end
end
