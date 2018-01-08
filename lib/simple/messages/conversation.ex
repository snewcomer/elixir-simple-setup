defmodule Simple.Messages.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Simple.Messages.Conversation


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    field :body, :string
    field :is_locked, :boolean, default: false
    field :read_at, :utc_datetime, null: true
    field :receive_notifications, :boolean, default: false
    field :status, :string
    field :title, :string

    belongs_to :user, Simple.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Conversation{} = conversation, attrs) do
    conversation
    |> cast(attrs, [:body, :title, :is_locked, :receive_notifications, :read_at, :status])
    |> validate_inclusion(:status, statuses())
    |> validate_required([:body, :title])
  end

  defp statuses do
    ~w{ open closed }
  end
end
