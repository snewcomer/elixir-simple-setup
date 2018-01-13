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
    field :guest, :boolean
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :ph_number, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:cloudinary_public_id, :username, :password, :email, 
      :first_name, :last_name, :guest])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 1, max: 39)
  end

  @doc false
  def update_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
  end

  @doc false
  def update_guest_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
    |> put_change(:guest, false)
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:default_color])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> generate_icon_color(:default_color)
  end

  @doc false
  def create_guest_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:default_color, :guest, :username])
    |> validate_required([:username])
    |> validate_length(:username, min: 1, max: 39)
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
