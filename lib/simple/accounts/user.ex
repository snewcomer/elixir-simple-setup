defmodule Simple.Accounts.User do
  use Simple.Model

  import Simple.Helpers.RandomIconColor
  alias Simple.Accounts.User
  alias Comeonin.Bcrypt
  alias Ecto.Changeset


  schema "users" do
    field :admin, :boolean
    field :cloudinary_public_id
    field :default_color
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:admin, :cloudinary_public_id, :username, :password, :email, :first_name, :last_name])
    |> validate_required([:username, :email, :first_name, :last_name])
  end

  @doc false
  def update_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:default_color])
    |> validate_required([:password, :username, :email])
    |> validate_length(:password, min: 6)
    |> validate_length(:username, min: 1, max: 39)
    |> unique_constraint(:email)
    |> validate_required([:username, :email, :first_name, :last_name])
    |> put_pass_hash()
    |> generate_icon_color(:default_color)
  end

  @doc false
  def reset_password_changeset(struct, params) do
    struct
    |> cast(params, [:password, :password_confirmation])
    |> validate_confirmation(:password, message: "passwords do not match")
    |> put_pass_hash
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
