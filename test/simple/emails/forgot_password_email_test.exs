defmodule Simple.Emails.ForgotPasswordEmailTest do
  use Simple.DataCase
  use Bamboo.Test

  import Simple.Factories

  alias Simple.{Emails.ForgotPasswordEmail, WebClient}
  alias Simple.Accounts.AuthToken

  test "forgot password email works" do
    user = insert(:user)
    { :ok, %AuthToken{ value: token } } = AuthToken.changeset(%AuthToken{}, user) |> Repo.insert()

    email = ForgotPasswordEmail.create(user, token)
    assert email.from == "Simple <team@simple.org>"
    assert email.to == user.email
    { :link, encoded_link } = email.private.template_model |> Enum.at(0)
    assert "#{WebClient.url()}/password/reset?token=#{token}" == encoded_link
  end
end
