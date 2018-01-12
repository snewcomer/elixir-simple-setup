defmodule Simple.WebClient do
  @moduledoc ~S"""
  Confirms URLs for the web client app routes
  """
  alias Simple.Accounts.{
    User
  }

  @doc ~S"""
  Returns the web client site root URL
  """
  @spec url :: String.t
  def url, do: Application.get_env(:simple, :site_url)

  @doc ~S"""
  Return the web client site url for the specified record
  """
  @spec url(User.t) :: String.t
  def url(%User{username: username}), do: url() <> "/" <> username
end
