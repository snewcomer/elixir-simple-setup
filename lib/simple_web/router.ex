defmodule SimpleWeb.Router do
  use SimpleWeb, :router

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  pipeline :current_user do
    plug SimpleWeb.Plug.CurrentUser
  end

  pipeline :bearer_auth do
    plug Simple.Auth.BearerAuthPipeline
  end

  pipeline :ensure_auth do
    plug Simple.Auth.EnsureAuthPipeline
  end

  scope "/api", SimpleWeb do
    pipe_through [:api, :bearer_auth, :current_user]
    resources "/users", UserController
  end

  scope "/", SimpleWeb do
    get "/*catch_all", AppController, :index
  end
end
