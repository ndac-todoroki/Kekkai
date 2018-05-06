defmodule KekkaiWeb.Router do
  use KekkaiWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KekkaiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/users", UserController, :index
  end

  scope "/auth", KekkaiWeb do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", KekkaiWeb do
  #   pipe_through :api
  # end
end
