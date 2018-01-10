defmodule SimpleWeb.Plug.DataToAttributes do
  @moduledoc ~S"""
  Converts params in the JSON api format into flat params convient for
  changeset casting.

  For included records, this is done using custom code.
  """

  alias Plug.Conn

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Conn.t, Keyword.t) :: Plug.Conn.t
  def call(%Conn{params: %{} = params} = conn, opts \\ []) do
    attributes =
      params
      |> Map.delete("data")
      |> Map.delete("included")
      |> Map.merge(params |> parse_data())
      |> Map.merge(params |> parse_included(opts))

    conn |> Map.put(:params, attributes)
  end

  @spec parse_data(map) :: map
  defp parse_data(%{"data" => data}), do: to_attributes(data)
  defp parse_data(%{}), do: %{}

  @spec parse_included(map, Keyword.t) :: map
  defp parse_included(%{"included" => included}, opts) do
    included |> Enum.reduce(%{}, fn (%{"data" => %{"type" => type}} = params, parsed) ->
      attributes = params |> parse_data()

      if opts |> Keyword.get(:includes_many, []) |> Enum.member?(type) do
        # this is an explicitly specified has_many,
        # update existing data by adding new record
        pluralized_type = type |> Inflex.pluralize
        parsed |> Map.update(pluralized_type, [attributes], fn data ->
          data ++ [attributes]
        end)
      else
        # this is a belongs to, put a new submap into payload
        parsed |> Map.put(type, attributes)
      end
    end)
  end
  defp parse_included(%{}, _opts), do: %{}

  # direct copy from https://github.com/vt-elixir/ja_serializer/blob/master/lib/ja_serializer/params.ex 
  defp to_attributes(%{"data" => data}), do: to_attributes(data)
  defp to_attributes(data) do
    data
    |> parse_relationships
    |> Map.merge(parse(data["attributes"]) || %{})
    |> Map.put_new("id", data["id"])
    |> Map.put_new("type", data["type"])
  end

  defp parse_relationships(%{"relationships" => rels}) do
    Enum.reduce rels, %{}, fn
      ({name, %{"data" => nil}}, rel) ->
        Map.put(rel, "#{name}_id", nil)
      ({name, %{"data" => %{"id" => id}}}, rel) ->
        Map.put(rel, "#{name}_id", id)
      ({name, %{"data" => ids}}, rel) when is_list(ids) ->
        Map.put(rel, "#{name}_ids", Enum.map(ids, &(&1["id"])))
    end
  end
  defp parse_relationships(_) do
    %{}
  end

  def parse(map) do
    Enum.reduce map, %{}, fn({key, val}, int_map) ->
      key = format_key(key)
      Map.put(int_map, key, val)
    end
  end

  def format_key(key) do
    dash_to_underscore(key)
  end

  defp dash_to_underscore(key), do: String.replace(key, "-", "_")
end
