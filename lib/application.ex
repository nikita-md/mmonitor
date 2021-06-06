defmodule Mmonitor.Application do
  use Application

  def start(_type, _args) do
    children = [
      Mmonitor.Checker,
      Mmonitor.State
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

  def children(_), do: []
end
