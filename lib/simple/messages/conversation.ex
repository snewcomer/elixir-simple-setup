defmodule Simple.Messages.Conversation do
  @moduledoc """
  The user may be a guest user or user registered with the system.
  The user is the one who generated the conversation

  The recipients are defined as thos who were "invited in" to the conversation.
  """

  use Simple.Model

  alias Simple.Messages.{Conversation, ConversationPart}
  alias Simple.Accounts.{User}

  schema "conversations" do
    field :body, :string
    field :is_locked, :boolean, default: false
    field :read_at, :utc_datetime, null: true
    field :notified, :boolean, default: false
    field :receive_notifications, :boolean, default: false
    field :status, :string, null: false, default: "open"
    field :title, :string

    belongs_to :user, User
    has_many :conversation_parts, ConversationPart

    timestamps()
  end

  @doc false
  def changeset(%Conversation{} = conversation, attrs) do
    conversation
    |> cast(attrs, [:body, :title, :is_locked, :notified, :receive_notifications, :read_at, :user_id])
    |> validate_required([:body, :title, :user_id])
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
end
