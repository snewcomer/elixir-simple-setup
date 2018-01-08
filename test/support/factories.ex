defmodule Simple.Factories do
  @moduledoc false

  # with Ecto
  use ExMachina.Ecto, repo: Simple.Repo

  alias Simple.Accounts.User

  def user_factory do
    %User{
      first_name: sequence(:first_name, &"First#{&1}"),
      username: sequence(:username, &"user#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def conversation_factory do
    %Simple.Messages.Conversation{
      body: sequence(:body, &"Body#{&1}"),
      status: "open",
      title: sequence(:body, &"Title#{&1}"),
      read_at: nil,
      user: build(:user)
    }
  end

  # def conversation_part_factory do
  #   %Simple.ConversationPart{
  #     body: sequence(:body, &"Reply to conversation #{&1}"),
  #     read_at: nil,
  #     author: build(:user),
  #     conversation: build(:conversation)
  #   }
  # end
end