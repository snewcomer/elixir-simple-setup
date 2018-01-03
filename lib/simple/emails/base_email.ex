defmodule Simple.Emails.BaseEmail do
  @moduledoc false

  import Bamboo.Email

  def create do
    new_email()
    |> from("Simple<team@simple.com>")
  end
end
