defmodule TeacExampleWeb.Router do
  use TeacExampleWeb, :router

  import TeacExampleWeb.UserAuth,
    only: [redirect_if_user_is_authenticated: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TeacExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeacExampleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    get "/oauth/callbacks/:provider", OAuthCallbackController, :new
  end

  scope "/", TeacExampleWeb do
    pipe_through :browser

    get "/", RedirectController, :redirect_authenticated

    delete "/signout", OAuthCallbackController, :sign_out

    live_session :default, on_mount: [{TeacExampleWeb.UserAuth, :current_user}] do
      live "/signin", SignInLive, :index
    end

    live_session :authenticated,
      on_mount: [{TeacExampleWeb.UserAuth, :ensure_authenticated}] do
      live "/profile/settings", SettingsLive, :edit
      live "/twitch", TwitchLive, :home
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TeacExampleWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
