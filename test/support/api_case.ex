defmodule SimpleWeb.ApiCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection, specificaly,
  those working with the API endpoints.

  It's basically a clone of SimpleWeb.ConnCase, with some extras,
  mainly authentication and proper headers, added.

  If provided with a :resource_name option, it dynamically
  generates higher level request helper methods

  ## Examples

    use ApiCase, resource_name: :task
    use ApiCase, resource_name: :comment
  """

  import Simple.Factories
  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  using(opts) do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Simple.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Simple.AuthenticationTestHelpers
      import SimpleWeb.Router.Helpers
      import Simple.Factories
      import Simple.TestHelpers

      # The default endpoint for testing
      @endpoint SimpleWeb.Endpoint

      SimpleWeb.ApiCase.define_request_helper_methods(unquote(opts))
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Simple.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Simple.Repo, {:shared, self()})
    end

    conn = cond do
      true ->
        %{build_conn() | host: "api."}
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
      end

    {conn, current_user} = cond do
      tags[:authenticated] ->
        conn |> add_authentication_headers(tags[:authenticated])
      true ->
        {conn, nil}
      end

    {:ok, conn: conn, current_user: current_user}
  end

  defp add_authentication_headers(conn, true) do
    user = insert(:user)
    conn = conn |> Simple.AuthenticationTestHelpers.authenticate(user)
    {conn, user}
  end

  defp add_authentication_headers(conn, :admin) do
    admin = insert(:user, admin: true)
    conn = conn |> Simple.AuthenticationTestHelpers.authenticate(admin)
    {conn, admin}
  end

  defmacro define_request_helper_methods(resource_name: resource_name), do: do_add_request_helper_methods(resource_name)
  defmacro define_request_helper_methods(_), do: nil

  defp do_add_request_helper_methods(resource_name) do
    quote do
      defp factory_name, do: unquote(resource_name)
      defp path_helper_method, do: "#{unquote(resource_name)}_path" |> String.to_atom
      defp default_record, do: insert(unquote(resource_name))

      defp path_for(conn, action, resource_or_id) do
        apply(SimpleWeb.Router.Helpers, path_helper_method(), [conn, action, resource_or_id])
      end

      defp path_for(conn, action) do
        apply(SimpleWeb.Router.Helpers, path_helper_method(), [conn, action])
      end

      def request_index(conn) do
        path = conn |> path_for(:index)
        conn |> get(path)
      end

      def request_show(conn, :not_found), do: conn |> request_show(-1)
      def request_show(conn, resource_or_id) do
        path = conn |> path_for(:show, resource_or_id)
        conn |> get(path)
      end

      def request_create(conn, attrs \\ %{}) do
        path = conn |> path_for(:create)
        payload = Simple.JsonAPIHelpers.build_json_payload(attrs, factory_name() |> Atom.to_string)
        conn |> post(path, payload)
      end

      def request_update(conn), do: request_update(conn, %{})
      def request_update(conn, :not_found), do: request_update(conn, "2b7934d0-4886-4d64-a688-06aa9505b5b0", %{})
      def request_update(conn, attrs), do: request_update(conn, default_record().id, attrs)
      def request_update(conn, resource_or_id, attrs) do
        payload = Simple.JsonAPIHelpers.build_json_payload(attrs, factory_name() |> Atom.to_string, resource_or_id)
        path = conn |> path_for(:update, resource_or_id)
        conn |> put(path, payload)
      end

      def request_delete(conn), do: request_delete(conn, default_record())
      def request_delete(conn, :not_found), do: request_delete(conn, "2b7934d0-4886-4d64-a688-06aa9505b5b0")
      def request_delete(conn, resource_or_id) do
        path = conn |> path_for(:delete, resource_or_id)
        conn |> delete(path)
      end
    end
  end
end
