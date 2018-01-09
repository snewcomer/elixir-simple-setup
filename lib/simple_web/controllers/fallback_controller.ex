defmodule SimpleWeb.FallbackController do
  @moduledoc false
  use SimpleWeb, :controller

  alias Ecto.Changeset

  @type supported_fallbacks :: {:error, Changeset.t} |
                               {:error, :not_authorized} |
                               nil

  @doc ~S"""
  Default fallback for different `with` clause errors in controllers across the
  application.
  """
  @spec call(Conn.t, supported_fallbacks) :: Conn.t
  def call(%Conn{} = conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(SimpleWeb.ChangesetView, "422.json", changeset: changeset)
  end
  def call(%Conn{} = conn, {:error, :not_authorized}) do
    conn
    |> put_status(403)
    |> render(SimpleWeb.TokenView, "403.json", message: "You are not authorized to perform this action.")
  end
  def call(%Conn{} = conn, {:error, :expired}) do
    conn
    |> put_status(:not_found)
    |> render(SimpleWeb.ErrorView, "404.json", %{})
  end
  def call(%Conn{} = conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(SimpleWeb.ErrorView, "404.json", %{})
  end
end
