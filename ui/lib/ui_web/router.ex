defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :reveal_static do
    plug(Plug.Static,
      at: "/js/reveal.js/",
      from: {:ui, "priv/revealjs_assets/reveal.js/"},
      gzip: false
    )
  end

  scope "/js/reveal.js/", UiWeb do
    pipe_through(:reveal_static)
    get("/*not_found", PageController, :not_found)
  end

  pipeline :markdown_static do
    plug(Plug.Static,
      at: "/slides/images/",
      from: {:ui, "priv/data/slides/images/"},
      gzip: false
    )
  end

  scope "/slides/images/", UiWeb do
    pipe_through(:markdown_static)
    get("/*not_found", PageController, :not_found)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {UiWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UiWeb do
    pipe_through(:browser)

    get("/", SlidesController, :home)
    get("/f", SlidesController, :from_files)
    get("/reset", SlidesController, :reset_db)
    live("/home", PageLive, :index)

    live("/slides", SlideLive.Index, :index)
    live("/slides/new", SlideLive.Index, :new)
    live("/slides/:id/edit", SlideLive.Index, :edit)

    live("/slides/:id", SlideLive.Show, :show)
    live("/slides/:id/show/edit", SlideLive.Show, :edit)
  end

  # Other scopes may use custom stacks.
  scope "/api", UiWeb do
    pipe_through(:api)

    get("/", SlidesController, :as_json)
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:ui, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      # live_dashboard "/dashboard", metrics: UiWeb.Telemetry
    end
  end
end
