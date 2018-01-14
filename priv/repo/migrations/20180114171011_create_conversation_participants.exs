defmodule Simple.Repo.Migrations.CreateConversationParticipant do
  use Ecto.Migration

  def change do
    create table(:conversation_participants, primary_key: false) do
      add :conversation_id, references(:conversations, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
    end

    create index(:conversation_participants, [:conversation_id])
    create index(:conversation_participants, [:user_id])
  end
end
