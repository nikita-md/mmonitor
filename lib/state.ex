defmodule Mmonitor.State do
  use Agent

  @name :state

  def start_link(_) do
    Agent.start_link fn -> %{} end, name: @name
  end

  def update(key, value, state \\ @name) do
    Agent.update(state, fn data -> Map.put(data, key, value) end)
  end

  def alert_details(state \\ @name) do
    Agent.get(state, fn data -> data[:alert_details] end)
  end

  def clear_alert_details(state \\ @name) do
    Agent.update(state, fn _ -> %{} end)
  end

  def get_all(state \\ @name) do
    Agent.get(state, fn data -> data end)
  end
end
