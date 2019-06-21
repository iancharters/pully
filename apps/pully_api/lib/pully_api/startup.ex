defmodule PullyAPI.Startup do
  alias Circuits.GPIO

  @nerves_booted_led 5

  def init do
    {:ok, pid} = GPIO.open(@nerves_booted_led, :output)

    GPIO.write(pid, 0)
  end
end
