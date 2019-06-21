defmodule PullyAPIWeb.MotorController do
  require Logger

  use PullyAPIWeb, :controller

  alias PullyAPI.Motor
  alias PullyAPIWeb.MotorView

  def move(conn, params) do
    PullyAPI.Store.get()
    |> Motor.move(params["direction"])

    render(conn, MotorView, "200.json", command: params["direction"])
  end

  def close(conn, _params) do
    PullyAPI.Store.get()
    |> Motor.close()

    render(conn, MotorView, "200.json", command: "close")
  end
end
