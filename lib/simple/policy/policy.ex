defmodule Simple.Policy do
  @moduledoc ~S"""
  Handles authorization for various API actions performed on objects in the database.
  """

  alias Simple.Accounts.{User}
  alias Simple.Messages.{Conversation}
  alias Simple.Policy

  @doc ~S"""
  Determines if the specified user can perform the specified action on the
  specified resource.

  The resource can be a record, when performing an action on an existing record,
  or it can be a map of parameters, when creating a new record.
  """
  @spec authorize(User.t, atom, struct, map) :: {:ok, :authorized} | {:error, :not_authorized}
  def authorize(%User{} = user, action, struct, %{} = params \\ %{}) do
    case user |> can?(action, struct, params) do
      true -> {:ok, :authorized}
      false -> {:error, :not_authorized}
    end
  end

  def scope(Conversation, %User{} = current_user), do: Conversation |> Policy.Conversation.scope(current_user)

  # Conversation
  defp can?(%User{} = current_user, :show, %Conversation{} = conversation, %{}), do: Policy.Conversation.show?(current_user, conversation)
  defp can?(%User{} = current_user, :update, %Conversation{} = conversation, %{}), do: Policy.Conversation.update?(current_user, conversation)

  # User
  @spec can?(User.t, atom, struct, map) :: boolean
  defp can?(%User{} = current_user, :update, %User{} = user, %{}), do: Simple.Policy.User.update?(current_user, user)

end
