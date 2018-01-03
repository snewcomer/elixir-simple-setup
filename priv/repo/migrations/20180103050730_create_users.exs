defmodule Simple.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :password, :string
      add :encrypted_password, :string
      add :email, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

  end
end
