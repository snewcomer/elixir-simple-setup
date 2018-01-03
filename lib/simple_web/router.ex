defmodule SimpleWeb.Router do
  use SimpleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SimpleWeb do
    pipe_through :api
  end

  scope "/", SimpleWeb do
    get "/*catch_all", AppController, :index
  end
end
