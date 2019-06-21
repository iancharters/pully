defmodule PullyAPIWeb.MotorView do
  use PullyAPIWeb, :view

  def render("200.json", %{command: command}) do
    %{
      status: 200,
      command: command
    }
  end
end
