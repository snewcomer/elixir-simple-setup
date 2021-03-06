defmodule Simple.Repo.Migrations.CreateAuthToken do
  use Ecto.Migration

  def change do
    create table(:auth_token) do
      add :value, :string

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:auth_token, [:user_id])
  end
end
