defmodule Simple.Repo.Migrations.CreateConversationParts do
  use Ecto.Migration

  def change do
    create table(:conversation_parts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :string, null: false
      add :read_at, :utc_datetime, null: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :conversation_id, references(:conversations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:conversation_parts, [:user_id])
    create index(:conversation_parts, [:conversation_id])
  end
end
