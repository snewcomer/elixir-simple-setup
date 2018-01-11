defmodule Simple.Messages.ConversationPart do
  use Simple.Model

  alias Simple.Messages.{Conversation, ConversationPart}
  alias Simple.Accounts.{User}

  schema "conversation_parts" do
    field :body, :string, null: false
    field :read_at, :utc_datetime, null: true

    belongs_to :user, User
    belongs_to :conversation, Conversation

    timestamps()
  end

  @doc false
  def changeset(%ConversationPart{} = conversation_part, attrs) do
    conversation_part
    |> cast(attrs, [:body, :read_at, :conversation_id, :user_id])
    |> validate_required([:body, :conversation_id, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:conversation)
  end
end
