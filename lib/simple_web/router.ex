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

  scope "/", SimpleWeb, host: "api." do
    pipe_through [:api, :bearer_auth, :ensure_auth, :current_user]
    resources "/users", UserController, only: [:index, :update, :delete]
    resources "/conversations", ConversationController, only: [:index, :create, :show, :update, :delete]
    resources "/conversation-parts", ConversationPartController, only: [:index, :create, :show, :update, :delete]
  end

  scope "/", SimpleWeb, host: "api." do
    pipe_through [:api, :bearer_auth, :current_user]
    post "/password/reset", PasswordResetController, :reset_password
    post "/password/forgot", PasswordController, :forgot_password
    get "/users/email_available", UserController, :email_available
    get "/users/username_available", UserController, :username_available
    resources "/users", UserController, only: [:show, :create]
  end

  scope "/", SimpleWeb do
    get "/*catch_all", AppController, :index
  end
end
