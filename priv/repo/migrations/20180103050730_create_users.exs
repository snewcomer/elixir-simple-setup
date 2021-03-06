defmodule Simple.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :admin, :boolean, null: false, default: false
      add :cloudinary_public_id, :string
      add :description, :string
      add :default_color, :string
      add :guest, :boolean, null: false, default: false
      add :username, :string
      add :encrypted_password, :string
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :ph_number, :string

      timestamps()
    end

    create index(:users, [:email], unique: true)
  end
end
