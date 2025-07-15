defmodule TeacExample.TwitchOAuthClient do
  @moduledoc """
  Twitch OAuth client using Req for HTTP requests.
  """
  def authorize_url() do
    Teac.OAuth.AuthorizationCodeFlow.authorize_url(
      scope: [
        Teac.Scopes.User.edit_broadcast(),
        Teac.Scopes.User.read_email(),
        Teac.Scopes.User.manage_chat_color()
      ]
    )
  end

  def exchange_code_for_token(opts) do
    Teac.OAuth.AuthorizationCodeFlow.exchange_code_for_token(opts)
  end
end
