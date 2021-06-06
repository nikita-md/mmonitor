defmodule Mmonitor.HttpClient.Sms do
  @base_url "https://api.twilio.com"

  def send(message) do
    HTTPoison.post(
      "#{@base_url}/2010-04-01/Accounts/AC3ace91df7561e743e47096c9d9d26893/Messages.json",
      prepare_body(message),
      headers()
    )
  end

  def headers do
    %{
      "Content-Type" => "application/x-www-form-urlencoded",
      "Authorization" => auth_token()
    }
  end

  defp prepare_body(message) do
    URI.encode_query(%{
      To: System.get_env("TWILIO_RECEIPIENT_PHONE_NUMBER"),
      MessagingServiceSid: System.get_env("TWILIO_MESSAGING_SERVICE_ID"),
      Body: message
    })
  end

  defp auth_token do
    "Basic #{Base.encode64("#{System.get_env("TWILIO_ACCOUNT_SID")}:#{System.get_env("TWILIO_AUTH_TOKEN")}")}"
  end
end
