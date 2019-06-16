defmodule PullyAPIWeb.Router do
  use PullyAPIWeb, :router

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

  scope "/", PullyAPIWeb do
    pipe_through :browser

    get "/", PageController, :index
    forward "/video.mjpg", Streamer
  end

  # Other scopes may use custom stacks.
  # scope "/api", PullyAPIWeb do
  #   pipe_through :api
  # end
end
