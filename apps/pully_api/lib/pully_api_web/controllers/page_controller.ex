defmodule PullyAPIWeb.PageController do
  use PullyAPIWeb, :controller

  def index(conn, _params) do
    IO.puts("PUTS")
    IO.inspect(%{inspect: "INSPECT"})

    render(conn, "index.html", params: %{test: "test_param"})
  end

  def move(conn, %{direction: direction}) do
  end

  def stop(conn, _params) do
  end
end
