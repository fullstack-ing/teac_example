defmodule TeacExampleWeb.PageController do
  use TeacExampleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def bits_cheermotes_get(conn, _) do
    {:ok, cheermotes} =
      Teac.Api.Bits.Cheermotes.get(token: Teac.Oauth.ClientCredentialManager.get_token())

    render(conn, :bits_cheermotes_get, cheermotes: cheermotes)
  end

  def channels_get(conn, _) do
    {:ok, channels} =
      Teac.Api.Channels.get(
        broadcaster_ids: 1_159_034_889,
        token: Teac.Oauth.ClientCredentialManager.get_token()
      )

    render(conn, :channels_get, channels: channels)
  end

  def chat_emotes_global_get(conn, _) do
    {:ok, emotes} =
      Teac.Api.Chat.Emotes.Global.get(token: Teac.Oauth.ClientCredentialManager.get_token())

    render(conn, :chat_emotes_global_get, emotes: emotes)
  end

  def chat_emotes_set_get(conn, _) do
    {:ok, emotes} =
      Teac.Api.Chat.Emotes.Set.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        emote_set_id: 463_722_755
      )

    render(conn, :chat_emotes_set_get, emotes: emotes)
  end

  def chat_emotes_get(conn, _) do
    {:ok, emotes} =
      Teac.Api.Chat.Emotes.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 27_082_158
      )
      |> dbg()

    render(conn, :chat_emotes_get, emotes: emotes)
  end

  def chat_badges_get(conn, _) do
    {:ok, badges} =
      Teac.Api.Chat.Badges.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 27_082_158
      )
      |> dbg()

    render(conn, :chat_badges_get, badges: badges)
  end

  def chat_badges_global_get(conn, _) do
    {:ok, badges} =
      Teac.Api.Chat.Badges.Global.get(token: Teac.Oauth.ClientCredentialManager.get_token())
      |> dbg()

    render(conn, :chat_badges_global_get, badges: badges)
  end

  def users_get(conn, _) do
    {:ok, users} =
      Teac.Api.Users.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        logins: ["lordtocs", "fullstacking", "qiqi_impact"]
      )

    render(conn, :users_get, users: users)
  end

  def twitch(conn, params) do
    dbg([conn, params])
    text(conn, :ok)
  end
end
