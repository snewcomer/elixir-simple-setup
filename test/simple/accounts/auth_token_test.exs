defmodule Simple.AuthTokenTest do
  use Simple.DataCase

  import Simple.Factories

  alias Simple.Accounts.AuthToken

  describe "auth token" do
    test "changeset with valid attributes" do
      user = insert(:user)
      changeset = AuthToken.changeset(%AuthToken{}, user)
      assert changeset.valid?
      assert changeset.changes.value
    end
  end
end
