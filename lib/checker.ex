defmodule Mmonitor.Checker do
  use GenServer
  alias Mmonitor.{State, HttpClient.Ethermine, HttpClient.Sms}

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule()
    {:ok, state}
  end

  def handle_info(:work, state) do
    check()
    schedule()
    {:noreply, state}
  end

  defp check() do
    { :ok, %{ "data" => workers } } = Ethermine.workers_stats()
    if hd(workers) |> hashrate_acceptable? do
      IO.puts("hashrate status is OK")
      State.clear_alert_details()
    else
      details = State.alert_details()
      if is_nil(details) || (DateTime.to_unix(DateTime.utc_now) - DateTime.to_unix(details[:time])) > 60 * 60 do
        IO.puts("hashrate is unacceptable: #{hd(workers)["reportedHashrate"]}")
        trigger_allert()
      end
    end
  end

  defp schedule() do
    Process.send_after(self(), :work, frequency())
  end

  defp trigger_allert() do
    unless System.get_env("TURN_OFF_ALERTS") == "true" do
      State.update(:alert_details, %{ time: DateTime.utc_now() })
      Sms.send("hashrate is unacceptable")
    end
  end

  defp hashrate_acceptable?(worker_info) do
    worker_info["reportedHashrate"] > hashrate_limit() && worker_info["currentHashrate"] > hashrate_limit()
  end

  defp frequency do
    elem(Integer.parse(System.get_env("CHECK_FREQUENCY_MINUTES")), 0) * 60 * 1000
  end

  defp hashrate_limit do
    elem(Integer.parse(System.get_env("HASHRATE_LIMIT")), 0) * 1_000_000
  end
end
