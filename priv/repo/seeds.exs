alias Simple.Accounts.User
alias Simple.Repo

users = [
  %{
    email: "owner@simple.org",
    first_name: "Simple",
    last_name: "Owner",
    password: "password",
    username: "simple-owner",
    admin: true
  },
  %{
    email: "admin@simple.org",
    first_name: "Simple",
    last_name: "Admin",
    password: "password",
    username: "simple-admin",
    admin: true
  },
  %{
    email: "contributor@simple.org",
    first_name: "Simple",
    last_name: "Contributor",
    password: "password",
    username: "simple-contributor"
  },
  %{
    email: "pending@simple.org",
    first_name: "Simple",
    last_name: "Pending",
    password: "password",
    username: "simple-pending"
  }
]

case Repo.all(User) do
  [] ->
    users
    |> Enum.map(fn params ->
      registration_changeset = User.create_changeset(%User{}, params)
      update_changeset = User.update_changeset(%User{}, params)

      registration_changeset
      |> Ecto.Changeset.merge(update_changeset)
      |> Repo.insert!()
    end)
  _ -> IO.puts "Users detected, aborting user seed."
end