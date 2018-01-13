defmodule Simple.Accounts.RemoveOldGuests do
  use Quantum.Scheduler,
    otp_app: :simple

  import Ecto.Query
  alias Simple.{Repo}
  alias Simple.Accounts.{User}

  def check_guest_users() do
    User
    |> where([u], u.guest == true and u.updated_at < datetime_add(^DateTime.utc_now(), -3, "day"))
    |> Repo.delete_all()
  end

end