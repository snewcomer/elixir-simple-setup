defmodule Simple.Policy.Helpers do
  @moduledoc """
  Holds helpers for extracting record relationships and determining roles for
  authorization policies.
  """

  alias Simple.Messages.{
    Conversation,
    ConversationPart
  }
  alias Simple.Repo
  alias Simple.Accounts.User

  alias Ecto.Changeset

    @doc """
  Determines if the provided project is being administered by the provided User

  Returns `true` if the user is an admin or higher member of the project
  """
  @spec administered_by?(Conversation.t(), User.t()) :: boolean
  def administered_by?(_, %User{} = user), do: user.admin
  def administered_by?(_, _), do: false

  @doc """
  Retrieves conversation from associated record
  """
  @spec get_conversation(Changeset.t() | ConversationPart.t() | map) :: Message.t()
  def get_conversation(%ConversationPart{conversation_id: conversation_id}), do: Repo.get(Conversation, conversation_id)
  def get_conversation(%{"conversation_id" => conversation_id}), do: Repo.get(Conversation, conversation_id)
  def get_conversation(%Changeset{changes: %{conversation_id: conversation_id}}), do: Repo.get(Conversation, conversation_id)
end
