defmodule Simple.Accounts.AuthToken do
  @moduledoc """
  Represents one of the user's many possible authentication tokens, created
  using `Phoenix.Token.sign/4`.

  Many can coexist and be valid at the same time. They can be used for
  password resets or passwordless logins.

  These tokens do expire based on the `max_age` value passed to
  `Phoenix.Token.verify/4`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  use Timex.Ecto.Timestamps

  schema "auth_token" do
    field :value, :string

    belongs_to :user, Simple.Accounts.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct`
  """
  def changeset(struct, user) do
    token = SimpleWeb.Endpoint |> Phoenix.Token.sign("user", user.id)
    struct
    |> cast(%{ value: token, user_id: user.id }, [:value, :user_id])
    |> validate_required([:value, :user_id])
    |> assoc_constraint(:user)
  end
end
