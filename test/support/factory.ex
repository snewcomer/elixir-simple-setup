defmodule Simple.Factory do
  alias Simple.Repo

  def build(:conversation_part) do
    %Simple.Messages.ConversationPart{
      id: Ecto.UUID.generate(),
      body: "hello world",
      user: build(:user)
    }
  end
  def build(:conversation) do
    %Simple.Messages.Conversation{
      id: Ecto.UUID.generate(),
      body: "good post",
      user: build(:user)
    }
  end
  def build(:conversation_with_parts) do
    %Simple.Messages.Conversation{
      id: Ecto.UUID.generate(),
      title: "hello with parts",
      user: build(:user),
      conversation_parts: [
        build(:conversation_part, body: "first")
      ]
    }
  end
  def build(:user) do
    %Simple.Accounts.User{
      id: Ecto.UUID.generate(),
      email: "hello#{System.unique_integer()}",
      username: "hello#{System.unique_integer()}",
      default_color: "blue"
    }
  end

  # Convenience API
  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end
  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end