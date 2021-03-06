defmodule SimpleWeb.ChangesetView do
  @moduledoc false
  use SimpleWeb, :view

  import SimpleWeb.Gettext

  alias Ecto.Changeset

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `SimpleWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(%Ecto.Changeset{} = changeset) do
    errors =
      changeset
      |> Changeset.traverse_errors(&translate_error/1)
      |> format_errors()
    errors
  end

  defp format_errors(errors) do
    errors
    |> Map.keys
    |> Enum.map(fn(attribute) -> format_attribute_errors(errors, attribute) end)
    |> Enum.flat_map(fn(error) -> error end)
  end

  defp format_attribute_errors(errors, attribute) do
    errors
    |> Map.get(attribute)
    |> Enum.map(&create_error(attribute, &1))
  end

  def create_error(attribute, message) do
    %{
      detail: format_detail(attribute, message),
      title: message,
      source: %{
        pointer: "data/attributes/#{format_key(attribute)}"
      },
      status: "422"
    }
  end

  def render("422.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      errors: translate_errors(changeset)
    }
  end

  defp format_detail(attribute, message) do
    "#{attribute |> humanize |> translate_attribute} #{message}"
  end

  defp translate_attribute("Cloudinary public"), do: dgettext("errors", "Cloudinary public")
  defp translate_attribute(attribute), do: attribute

  @doc false
  defp humanize(atom) when is_atom(atom), do: humanize(Atom.to_string(atom))
  defp humanize(str), do: String.capitalize(str)

  @doc false
  def format_key(k) when is_atom(k), do: k |> Atom.to_string |> format_key
  def format_key(key), do: do_format_key(key, :dasherized)

  def do_format_key(key, :dasherized),  do: String.replace(key, "_", "-")
end
