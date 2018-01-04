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
end