defmodule TeacExample.TwitchOAuthClient do
  @moduledoc """
  Twitch OAuth client using Req for HTTP requests.
  """
  def authorize_url() do
    Teac.OAuth.AuthorizationCodeFlow.authorize_url()
  end

  def exchange_code_for_token(opts) do
    Teac.OAuth.AuthorizationCodeFlow.exchange_code_for_token(opts)
  end
end
