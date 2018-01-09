defmodule Simple.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :string
      add :title, :string
      add :is_locked, :boolean, default: false, null: false
      add :receive_notifications, :boolean, default: false, null: false
      add :read_at, :utc_datetime, null: true
      add :status, :string, null: false, default: "open"
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:conversations, [:user_id])
  end
end
