defmodule PullyAPI.Motor do
  require Logger

  alias Circuits.GPIO

  # ENA - H-Bridge enable pin
  @drive_left_enable_pin 21
  # IN1 - Forward Drive
  @forward_left_pin 26
  # IN2 - Reverse Drive
  @reverse_left_pin 19

  # ENB - H-Bridge enable pin
  @drive_right_enable_pin 12
  # IN1 - Forward Drive
  @forward_right_pin 16
  # IN2 - Reverse Drive
  @reverse_right_pin 13

  @drive_led_pin 25

  def init() do
    Logger.info("Initializing pins...")
    {:ok, drive_led} = GPIO.open(@drive_led_pin, :output)
    {:ok, drive_left} = GPIO.open(@drive_left_enable_pin, :output)
    {:ok, drive_right} = GPIO.open(@drive_right_enable_pin, :output)
    {:ok, forward_left} = GPIO.open(@forward_left_pin, :output)
    {:ok, reverse_left} = GPIO.open(@reverse_left_pin, :output)
    {:ok, forward_right} = GPIO.open(@forward_right_pin, :output)
    {:ok, reverse_right} = GPIO.open(@reverse_right_pin, :output)

    pids = %{
      drive_led: drive_led,
      drive_left: drive_left,
      drive_right: drive_right,
      forward_left: forward_left,
      reverse_left: reverse_left,
      forward_right: forward_right,
      reverse_right: reverse_right
    }

    # Activate motor channels A and B.
    GPIO.write(drive_led, 1)
    GPIO.write(drive_left, 1)
    GPIO.write(drive_right, 1)

    Logger.info("Init pin #{inspect(@drive_left_enable_pin)}: #{inspect(drive_left)}")
    Logger.info("Init pin #{inspect(@drive_right_enable_pin)}: #{inspect(drive_right)}")
    Logger.info("Init pin #{inspect(@forward_left_pin)}: #{inspect(forward_left)}")
    Logger.info("Init pin #{inspect(@reverse_left_pin)}: #{inspect(reverse_left)}")
    Logger.info("Init pin #{inspect(@forward_right_pin)}: #{inspect(forward_right)}")
    Logger.info("Init pin #{inspect(@reverse_right_pin)}: #{inspect(reverse_right)}")

    pids
  end

  def move(pids, "stop") do
    Logger.info("STOP")

    Enum.each(pids, fn {k, v} ->
      should_change =
        k
        |> Atom.to_string()
        |> String.contains?(["forward", "reverse"])

      if should_change, do: GPIO.write(v, 0)
    end)
  end

  def move(pids, "forward") do
    Logger.info("FORWARD")
    GPIO.write(pids.reverse_right, 0)
    GPIO.write(pids.reverse_left, 0)
    GPIO.write(pids.forward_right, 1)
    GPIO.write(pids.forward_left, 1)
  end

  def move(pids, "forward-right") do
    Logger.info("FORWARD RIGHT")
  end

  def move(pids, "forward-left") do
    Logger.info("FORWARD LEFT")
  end

  def move(pids, "reverse") do
    Logger.info("REVERSE")
    GPIO.write(pids.forward_right, 0)
    GPIO.write(pids.forward_left, 0)
    GPIO.write(pids.reverse_right, 1)
    GPIO.write(pids.reverse_left, 1)
  end

  def move(pids, "reverse-right") do
    Logger.info("REVERSE RIGHT")
  end

  def move(pids, "reverse-left") do
    Logger.info("REVERSE LEFT")
  end

  def move(pids, "left") do
    Logger.info("left")
    GPIO.write(pids.forward_right, 0)
    GPIO.write(pids.forward_left, 1)
    GPIO.write(pids.reverse_right, 1)
    GPIO.write(pids.reverse_left, 0)
  end

  def move(pids, "right") do
    Logger.info("right")
    GPIO.write(pids.forward_right, 1)
    GPIO.write(pids.forward_left, 0)
    GPIO.write(pids.reverse_right, 0)
    GPIO.write(pids.reverse_left, 1)
  end

  def close(pids) do
    Logger.info("CLOSE")

    Enum.each(pids, fn {_k, v} ->
      GPIO.write(v, 0)
      GPIO.close(v)
    end)
  end
end
