defmodule Simple.Messages.ConversationParticipants do
  use Simple.Model
  import Ecto.Changeset
  alias Simple.Messages.ConversationParticipants


  schema "conversation_participants" do
    field :conversation_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%ConversationParticipants{} = conversation_participants, attrs) do
    conversation_participants
    |> cast(attrs, [])
    |> validate_required([])
  end
end
