defmodule SimpleWeb.ErrorViewTest do
  use SimpleWeb.ViewCase

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    rendered_json =  render(SimpleWeb.ErrorView, "404.json", [])

    expected_json = %{
      :errors => [%{title: "404 Not Found", detail: "404 Not Found", status: "404"}]
    }
    assert rendered_json == expected_json
  end

  test "renders 500.json" do
    rendered_json =  render(SimpleWeb.ErrorView, "500.json", [])

    expected_json = %{
      :errors => [%{title: "500 Internal Server Error", detail: "500 Internal Server Error", status: "500"}]
    }
    assert rendered_json == expected_json
  end

  test "render any other" do
    string = render_to_string(SimpleWeb.ErrorView, "505.json", [])

    assert String.contains? string, "Internal Server Error"
  end
end
