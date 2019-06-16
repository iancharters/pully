defmodule PullyAPI.Motor do
  require Logger

  alias Circuits.GPIO

  # ENA - H-Bridge enable pin
  @drive_left_enable 21
  # IN1 - Forward Drive
  @forward_left_pin 26
  # IN2 - Reverse Drive
  @reverse_left_pin 19

  # ENB - H-Bridge enable pin
  @drive_right_enable 12
  # IN1 - Forward Drive
  @forward_right_pin 13
  # IN2 - Reverse Drive
  @reverse_right_pin 16

  @led 25

  def init() do
    Logger.info("Initializing pins...")
    {:ok, led} = GPIO.open(@led, :output)
    {:ok, drive_left} = GPIO.open(@drive_left_enable, :output)
    {:ok, drive_right} = GPIO.open(@drive_right_enable, :output)
    {:ok, forward_left} = GPIO.open(@forward_left_pin, :output)
    {:ok, reverse_left} = GPIO.open(@reverse_left_pin, :output)
    {:ok, forward_right} = GPIO.open(@forward_right_pin, :output)
    {:ok, reverse_right} = GPIO.open(@reverse_right_pin, :output)

    pids = %{
      led: led,
      drive_left: drive_left,
      drive_right: drive_right,
      forward_left: forward_left,
      reverse_left: reverse_left,
      forward_right: forward_right,
      reverse_right: reverse_right
    }

    # Activate motor channels A and B.
    GPIO.write(led, 1)
    GPIO.write(drive_left, 1)
    GPIO.write(drive_right, 1)

    Logger.info("Init pin #{inspect(@drive_left_enable)}: #{inspect(drive_left)}")
    Logger.info("Init pin #{inspect(@drive_right_enable)}: #{inspect(drive_right)}")
    Logger.info("Init pin #{inspect(@forward_left_pin)}: #{inspect(forward_left)}")
    Logger.info("Init pin #{inspect(@reverse_left_pin)}: #{inspect(reverse_left)}")
    Logger.info("Init pin #{inspect(@forward_right_pin)}: #{inspect(forward_right)}")
    Logger.info("Init pin #{inspect(@reverse_right_pin)}: #{inspect(reverse_right)}")

    pids
  end

  def stop(pids) do
    Logger.info("stopping")

    Enum.each(pids, fn {k, v} ->
      should_change =
        k
        |> Atom.to_string()
        |> String.contains?("pin")

      if should_change, do: GPIO.write(v, 0)
    end)
  end

  def close(pids) do
    stop(pids)

    Enum.each(pids, fn {_k, v} ->
      GPIO.write(v, 0)
      GPIO.close(v)
    end)
  end

  def forward(pids) do
    Logger.info("forward")
    GPIO.write(pids.reverse_right, 0)
    GPIO.write(pids.reverse_left, 0)
    GPIO.write(pids.forward_right, 1)
    GPIO.write(pids.forward_left, 1)
  end

  def reverse(pids) do
    Logger.info("reverse")
    GPIO.write(pids.forward_right, 0)
    GPIO.write(pids.forward_left, 0)
    GPIO.write(pids.reverse_right, 1)
    GPIO.write(pids.reverse_left, 1)
  end

  def right(pids) do
    Logger.info("right")
    GPIO.write(pids.forward_right, 0)
    GPIO.write(pids.forward_left, 1)
    GPIO.write(pids.reverse_right, 1)
    GPIO.write(pids.reverse_left, 0)
  end

  def left(pids) do
    Logger.info("left")
    GPIO.write(pids.forward_right, 1)
    GPIO.write(pids.forward_left, 0)
    GPIO.write(pids.reverse_right, 0)
    GPIO.write(pids.reverse_left, 1)
  end
end
