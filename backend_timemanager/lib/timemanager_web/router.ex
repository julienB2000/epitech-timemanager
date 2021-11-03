defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TimemanagerWeb.LayoutView, :root}
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, [origin: "http://localhost:8080"]
    plug :accepts, ["json"]
    plug CORSPlug, origin: "*"
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api

    #get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :create, :update, :delete]

    scope "/clocks" do
      post "/:userID", ClockController, :create
      get "/:userID", ClockController, :index
      get "/useless/:userID", ClockController, :show
    end

    scope "/workingtimes" do
      resources "/", WorkingtimeController, only: [:show, :update, :delete]
      get "/users/:userID", WorkingtimeController, :index
      post "/:userID", WorkingtimeController, :create
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", TimemanagerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
