defmodule Simple.Guardian do
  use Guardian, otp_app: :simple

  alias Simple.Accounts.User
  alias Simple.Repo

  def subject_for_token(user = %User{}, _claims) do
    {:ok, "User:#{user.id}"}
  end
  def subject_for_token(_, _) do
    {:error, :unknown_resource_type}
  end

  def resource_from_claims(%{"sub" => sub}), do: resource_from_subject(sub)
  def resource_from_claims(_), do: {:error, :missing_subject}

  defp resource_from_subject("User:" <> id), do: {:ok, Repo.get(User, id)}
  defp resource_from_subject(_), do: {:error, :unknown_resource_type}
end
