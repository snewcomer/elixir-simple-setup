defmodule Simple.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Simple.Repo

  import Simple.Helpers.Query, only: [sort_by_inserted_at: 1]

  alias Simple.Messages.{Conversation, ConversationQuery}

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  @spec list_conversations(Queryable.t, map) :: list(Conversation.t)
  def list_conversations(query, params \\ %{}) do
    query
    |> ConversationQuery.status_filter(params)
    |> ConversationQuery.conversation_filter(params)
    |> Repo.all()
  end

  @doc """
  Gets a single conversation.

  Raises `Ecto.NoResultsError` if the Conversation does not exist.

  ## Examples

      iex> get_conversation(123)
      %Conversation{}

      iex> get_conversation(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation(id), do: Repo.get(Conversation, id)

  @doc """
  Creates a conversation.

  ## Examples

      iex> create_conversation(%{field: value})
      {:ok, %Conversation{}}

      iex> create_conversation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation.

  ## Examples

      iex> update_conversation(conversation, %{field: new_value})
      {:ok, %Conversation{}}

      iex> update_conversation(conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Conversation.

  ## Examples

      iex> delete_conversation(conversation)
      {:ok, %Conversation{}}

      iex> delete_conversation(conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation changes.

  ## Examples

      iex> change_conversation(conversation)
      %Ecto.Changeset{source: %Conversation{}}

  """
  def change_conversation(%Conversation{} = conversation) do
    Conversation.changeset(conversation, %{})
  end

  alias Simple.Messages.ConversationPart

  @doc """
  Returns the list of conversation_parts.

  ## Examples

      iex> list_conversation_parts()
      [%ConversationPart{}, ...]

  """
  def list_conversation_parts(query) do
    query |> sort_by_inserted_at() |> Repo.all()
  end

  @doc """
  Gets a single conversation_part.

  Raises `Ecto.NoResultsError` if the Conversation part does not exist.

  ## Examples

      iex> get_conversation_part!(123)
      %ConversationPart{}

      iex> get_conversation_part!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversation_part(id), do: Repo.get(ConversationPart, id)

  @doc """
  Creates a conversation_part.

  ## Examples

      iex> create_conversation_part(%{field: value})
      {:ok, %ConversationPart{}}

      iex> create_conversation_part(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversation_part(attrs \\ %{}) do
    %ConversationPart{}
    |> ConversationPart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a conversation_part.

  ## Examples

      iex> update_conversation_part(conversation_part, %{field: new_value})
      {:ok, %ConversationPart{}}

      iex> update_conversation_part(conversation_part, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_conversation_part(%ConversationPart{} = conversation_part, attrs) do
    conversation_part
    |> ConversationPart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ConversationPart.

  ## Examples

      iex> delete_conversation_part(conversation_part)
      {:ok, %ConversationPart{}}

      iex> delete_conversation_part(conversation_part)
      {:error, %Ecto.Changeset{}}

  """
  def delete_conversation_part(%ConversationPart{} = conversation_part) do
    Repo.delete(conversation_part)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking conversation_part changes.

  ## Examples

      iex> change_conversation_part(conversation_part)
      %Ecto.Changeset{source: %ConversationPart{}}

  """
  def change_conversation_part(%ConversationPart{} = conversation_part) do
    ConversationPart.changeset(conversation_part, %{})
  end
end
