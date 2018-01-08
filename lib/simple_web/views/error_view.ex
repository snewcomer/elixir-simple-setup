defmodule SimpleWeb.ErrorView do
  use SimpleWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "404 Not Found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  # def render("404.json-api", _assigns) do
  #   %{
  #     title: "404 Not Found",
  #     detail: "404 Not Found",
  #     status: "404"
  #   }
  # end

  # def render("500.json-api", _assigns) do
  #   %{
  #     title: "500 Internal Server Error",
  #     detail: "500 Internal Server Error",
  #     status: "500"
  #   }
  # end

  # # In case no render clause matches or no
  # # template is found, let's render it as 500
  # def template_not_found(_template, assigns) do
  #   render "500.json-api", assigns
  # end
end
