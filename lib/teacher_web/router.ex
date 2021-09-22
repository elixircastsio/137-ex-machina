defmodule TeacherWeb.Router do
  use TeacherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TeacherWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeacherWeb do
    pipe_through :browser

    live "/albums", AlbumLive.Index, :index
    live "/albums/new", AlbumLive.Index, :new
    live "/albums/:id/edit", AlbumLive.Index, :edit
    live "/albums/:id", AlbumLive.Show, :show
    live "/albums/:id/show/edit", AlbumLive.Show, :edit

    live "/albums/:album_id/reviews", ReviewLive.Index, :index
    live "/albums/:album_id/reviews/new", ReviewLive.Index, :new
    live "/albums/:album_id/reviews/:id/edit", ReviewLive.Index, :edit
    live "/albums/:album_id/reviews/:album_id/:id", ReviewLive.Show, :show
    live "/labums/:album_id/reviews/:id/show/edit", ReviewLive.Show, :edit

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TeacherWeb do
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
      live_dashboard "/dashboard", metrics: TeacherWeb.Telemetry
    end
  end
end
