defmodule Simple.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Simple.Accounts.User


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :encrypted_password, :email, :first_name, :last_name])
    |> validate_required([:username, :password, :encrypted_password, :email, :first_name, :last_name])
  end
end
