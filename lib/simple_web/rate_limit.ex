defmodule SimpleWeb.RateLimit do
  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn, only: [halt: 1, put_status: 2]

  def rate_limit(conn, options \\ []) do
    case check_rate(conn, options) do
      {:ok, _count}   -> conn # Do nothing, pass on to the next plug
      {:fail, _count} -> render_error(conn)
    end
  end

  def rate_limit_authentication(conn, options \\ []) do
    name = conn.params["username"] || conn.params["email"] || "random@gmail.com"
    options = Keyword.merge(options, [bucket_name: "authorization:" <> name])
    __MODULE__.rate_limit(conn, options)
  end

  defp check_rate(conn, options) do
    interval_milliseconds = Application.get_env(:simple, :interval_milliseconds)
    max_requests = Application.get_env(:simple, :max_requests)
    bucket_name = options[:bucket_name] || bucket_name(conn)

    ExRated.check_rate(bucket_name, interval_milliseconds, max_requests)
  end

  # Bucket name should be a combination of ip address and request path, like so:
  #
  # "127.0.0.1:/api/v1/authorizations"
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip   = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    "#{ip}:#{path}"
  end

  defp render_error(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Rate limit exceeded."})
    |> halt # Stop execution of further plugs, return response now
  end
end