defmodule PullyAPIWeb.PageView do
  use PullyAPIWeb, :view

  def forward do
    IO.puts("GO FORWARD")
    "go forward!"
  end
end
