defmodule SimpleWeb.PasswordView do
  @moduledoc false
  use SimpleWeb, :view

  def render("show.json", %{email: email}) do
    %{
      email: email
    }
  end

end
