defmodule Simple.Helpers.Query do
  import Ecto.Query, only: [where: 3, order_by: 2]

  alias Simple.Repo

  @spec id_filter(Ecto.Queryable.t, map | String.t) :: Ecto.Queryable.t
  def id_filter(query, %{"filter" => %{"id" => id_csv}}) do
    query |> id_filter(id_csv)
  end
  def id_filter(query, %{}), do: query
  def id_filter(query, id_list) when is_binary(id_list) do
    query |> where([object], object.id in ^id_list)
  end

  # user queries

  def login_filter(query, username_or_email) do
    query
    |> where([object], 
      object.username == ^username_or_email or
      object.email == ^username_or_email)
    |> Repo.one
  end

  def user_filter(query, %{"query" => query_string}) do
    query
    |> where(
      [object],
      ilike(object.first_name, ^"%#{query_string}%") or
      ilike(object.last_name, ^"%#{query_string}%") or
      ilike(object.username, ^"%#{query_string}%")
    )
  end
  def user_filter(query, _), do: query

  # end user queries

  # sorting

  def sort_by_inserted_at(query), do: query |> order_by([asc: :inserted_at])
  def sort_by_inserted_at_desc(query), do: query |> order_by([desc: :inserted_at])

  # end sorting

  # finders

  def slug_finder(query, slug) do
    query |> Repo.get_by(slug: slug |> String.downcase)
  end

  # end finders

  @doc ~S"""
  Applies optional filters by key-value to query dynamically.

  Used by piping a queryable with a map of parameters and a list of keys to
  filter by.

  For each key in the list, the params map has a value for that key,
  the query condition for that `{key, value}` is applied to the queriable.
  """
  @spec optional_filters(Ecto.Queryable.t, map, list) :: Ecto.Queryable.t
  def optional_filters(query, %{} = params, [key | other_keys]) do
    case params |> Map.get(key |> Atom.to_string) do
      nil -> query |> optional_filters(params, other_keys)
      value -> query |> where([o], field(o, ^key) == ^value)
    end
  end
  def optional_filters(query, %{} = _params, []), do: query
end
