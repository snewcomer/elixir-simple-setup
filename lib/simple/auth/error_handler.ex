defmodule Simple.Auth.ErrorHandler do
  use SimpleWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> render(SimpleWeb.TokenView, "401.json", message: to_string(type))
  end
end
