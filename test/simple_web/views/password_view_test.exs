defmodule SimpleWeb.PasswordViewTest do
  use SimpleWeb.ViewCase

  test "renders show" do
    email = "wat@Ssmple.org"

    rendered_json = render(SimpleWeb.PasswordView, "show.json", %{email: email})

    expected_json = %{
      email: email
    }

    assert expected_json == rendered_json
    refute Map.has_key?(expected_json, :token)
  end

end
