defmodule SimpleWeb.AppController do
  use Plug.Builder
  import Plug.Conn
  plug :index

  def index(conn, _params) do
    index = Path.expand("~/path/to/") <> "/index.html"
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_file(200, index)
  end
end