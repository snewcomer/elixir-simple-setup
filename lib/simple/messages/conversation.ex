defmodule Simple.Messages.Conversation do
  @moduledoc """
  The user may be a guest user or user registered with the system.
  The user is the one who generated the conversation
  A conversation can have many users, but only one author

  The recipients are defined as thos who were "invited in" to the conversation.
  """

  use Simple.Model
  import Ecto.Query

  alias Simple.Messages.{Conversation, ConversationPart}
  alias Simple.Accounts.{User}
  alias Simple.Repo

  schema "conversations" do
    field :body, :string
    field :is_locked, :boolean, default: false
    field :read_at, :utc_datetime, null: true
    field :notified, :boolean, default: false
    field :receive_notifications, :boolean, default: false
    field :status, :string, null: false, default: "open"
    field :title, :string

    belongs_to :user, User
    many_to_many :participants, User, join_through: "conversation_participants"

    has_many :conversation_parts, ConversationPart

    timestamps()
  end

  @doc """
  adds a m2m via put_assoc
  client sends list of participants as [%{id: .., type: ..}] and we convert to [id, id]
  """
  def changeset(%Conversation{} = conversation, attrs) do
    conversation
    |> cast(attrs, [:body, :title, :is_locked, :notified, :receive_notifications, :read_at, :user_id])
    |> validate_required([:body, :title, :user_id])
    |> put_participants(attrs)
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(struct, %{} = params) do
    struct
    |> changeset(params)
    |> cast(params, [:status])
    |> validate_inclusion(:status, statuses())
  end

  defp statuses do
    ~w{ open closed }
  end

  defp put_participants(changeset, params) do
    case params do
      %{"participants_ids" => participants_ids} ->
        participants =
          get_existing_users(participants_ids) 
          |> Enum.map(&Ecto.Changeset.change/1)

        put_assoc(changeset, :participants, participants)
      _ -> 
        changeset
    end
  end

  defp get_existing_users(ids) do
    Repo.all(from c in User, where: c.id in ^ids)
  end

end
