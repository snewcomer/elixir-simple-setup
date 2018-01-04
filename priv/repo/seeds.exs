alias Simple.Accounts.User
alias Simple.Repo

users = [
  %{
    email: "owner@codecorps.org",
    first_name: "Code Corps",
    last_name: "Owner",
    password: "password",
    username: "codecorps-owner"
  },
  %{
    email: "admin@codecorps.org",
    first_name: "Code Corps",
    last_name: "Admin",
    password: "password",
    username: "codecorps-admin"
  },
  %{
    email: "contributor@codecorps.org",
    first_name: "Code Corps",
    last_name: "Contributor",
    password: "password",
    username: "codecorps-contributor"
  },
  %{
    email: "pending@codecorps.org",
    first_name: "Code Corps",
    last_name: "Pending",
    password: "password",
    username: "codecorps-pending"
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