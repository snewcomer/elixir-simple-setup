defmodule Simple.Messages.ConversationQuery do
  @moduledoc ~S"""
  Holds helpers to query `Simple.Conversation` records using a map of params.
  """

  import Ecto.Query

  alias Ecto.Queryable

  @doc ~S"""
  Narrows down a `Simple.Conversation` query by `user_id`, if specified in a
  params map
  """
  @spec user_filter(Queryable.t, map) :: Queryable.t
  def user_filter(queryable, %{"user_id" => user_id}) do
    queryable
    |> where([c], c.user_id == ^user_id)
  end
  def user_filter(queryable, %{}), do: queryable


  # @doc ~S"""
  # Filters `Simple.Conversation` record queries to return only those
  # considered to be active.

  # Active conversations belong either:
  # - to a `Simple.Message` initiated by user
  # - to a `Simple.Message` initiated by an admin, with at least a single
  #   conversation part
  # """
  # @spec active_filter(Queryable.t, map) :: Queryable.t
  # def active_filter(queryable, %{"active" => true}) do
  #   prefiltered_ids = queryable |> select([c], c.id) |> Repo.all

  #   Conversation
  #   |> where([c], c.id in ^prefiltered_ids)
  #   |> join(:left, [c], m in Message, c.message_id == m.id)
  #   |> join(:left, [c, _m], cp in ConversationPart, c.id == cp.conversation_id)
  #   |> group_by([c, m, _cp], [c.id, m.initiated_by])
  #   |> having([_c, m, _cp], m.initiated_by == "user")
  #   |> or_having([c, m, cp], m.initiated_by == "admin" and count(cp.id) > 0)
  # end
  # def active_filter(query, %{}), do: query

  @doc ~S"""
  Filters `Simple.Conversation` record queries by their status.
  """
  @spec status_filter(Queryable.t, map) :: Queryable.t
  def status_filter(queryable, %{"status" => status}) do
    queryable
    |> where([c], c.status == ^status)
  end
  def status_filter(query, _), do: query
end
