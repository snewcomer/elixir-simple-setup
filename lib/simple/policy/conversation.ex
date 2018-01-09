defmodule Simple.Policy.Conversation do
  @moduledoc ~S"""
  Handles `Simple.User` authorization of actions on `Simple.Conversation`
  records.

  A user starts a conversation with an admin.  
  """

  import Ecto.Query

  alias Simple.Messages.{Conversation}
  alias Simple.Accounts.{User}

  @spec scope(Ecto.Queryable.t, User.t) :: Ecto.Queryable.t
  def scope(queryable, %User{admin: true}), do: queryable
  def scope(queryable, %User{id: id}) do
    queryable
    |> where(user_id: ^id)
  end

  def show?(%User{admin: true}, _conversation), do: true
  def show?(%User{id: user_id}, %Conversation{user_id: target_user_id})
    when user_id == target_user_id do
    true
  end
  def show?(_, _), do: false

  def update?(%User{admin: true}, _conversation), do: true
  def update?(%User{id: user_id}, %Conversation{user_id: target_user_id})
    when user_id == target_user_id do
    true
  end
  def update?(_, _), do: false

  def delete?(%User{admin: true}, _conversation), do: true
  def delete?(%User{id: user_id}, %Conversation{user_id: target_user_id})
    when user_id == target_user_id do
    true
  end
  def delete?(_, _), do: false
end
