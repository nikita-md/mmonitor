defmodule Mmonitor.HttpClient.Ethermine do
  @base_url "https://api.ethermine.org"

  def workers_stats() do
    {:ok, response} = HTTPoison.get("#{@base_url}/miner/#{System.get_env("ETH_WALLET_ID")}/workers")
    JSON.decode(response.body)
  end
end
