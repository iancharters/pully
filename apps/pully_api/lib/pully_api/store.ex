defmodule PullyAPI.Store do
  use Agent

  def start_link(opts) do
    {initial_value, opts} = Keyword.pop(opts, :initial_value, %{})
    Agent.start_link(fn -> initial_value end, opts)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def set(value) do
    Agent.update(__MODULE__, value)
  end
end
