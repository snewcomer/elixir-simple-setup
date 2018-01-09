defmodule SimpleWeb.ErrorView do
  use SimpleWeb, :view

  def render("404.json", _assigns) do
    %{
      title: "404 Not Found",
      detail: "404 Not Found",
      status: "404"
    }
    |> format
  end

  def render("500.json", _assigns) do
    %{
      title: "500 Internal Server Error",
      detail: "500 Internal Server Error",
      status: "500"
    }
    |> format
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  @error_fields ~w(id links about status code title detail source meta)a

  @doc false
  defp format(error) do
    errors = error |> Map.take(@error_fields) |> List.wrap
    %{errors: errors}
  end
end
