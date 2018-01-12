defmodule SimpleWeb.PasswordController do
  @moduledoc false
  use SimpleWeb, :controller

  alias Simple.{Services.ForgotPasswordService}

  @doc """
  Generates a `Simple.AuthToken` model to verify against and sends an email.
  """
  def forgot_password(conn, %{"email" => email}) do
    ForgotPasswordService.forgot_password(email)

    conn
    |> Simple.Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> render("show.json", email: email)
  end
end
