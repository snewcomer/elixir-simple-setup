defmodule Simple.Factories do
  @moduledoc false

  # with Ecto
  use ExMachina.Ecto, repo: Simple.Repo

  alias Simple.Accounts.User
  alias Simple.Messages.{Conversation, ConversationPart}

  def user_factory do
    %User{
      first_name: sequence(:first_name, &"First#{&1}"),
      username: sequence(:username, &"user#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def conversation_factory do
    %Conversation{
      body: sequence(:body, &"Body#{&1}"),
      status: "open",
      title: sequence(:body, &"Title#{&1}"),
      read_at: nil,
      user: build(:user)
    }
  end

  def conversation_part_factory do
    %ConversationPart{
      body: sequence(:body, &"Reply to conversation #{&1}"),
      read_at: nil,
      user: build(:user),
      conversation: build(:conversation)
    }
  end

  @spec set_password(Simple.Accounts.User.t, String.t) :: Simple.Accounts.User.t
  def set_password(user, password) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
    %{user | encrypted_password: hashed_password}
  end
end