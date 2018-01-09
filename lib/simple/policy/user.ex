defmodule Simple.Policy.User do
  @moduledoc ~S"""
  Contains authorization policies for performing actions on a `User` record.

  Used to authorize controller actions.
  """
  alias Simple.Accounts.User

  @spec update?(User.t, User.t) :: boolean
  def delete?(%User{admin: true}, _conversation), do: true
  def update?(%User{id: current_user_id}, %User{id: user_id})
    when current_user_id == user_id, do: true
  def update?(%User{}, %User{}), do: false

  @spec delete?(User.t, User.t) :: boolean
  def delete?(%User{admin: true}, _user), do: true
  def delete?(%User{id: current_user_id}, %User{id: user_id})
    when current_user_id == user_id, do: true
  def delete?(%User{}, %User{}), do: false
end
