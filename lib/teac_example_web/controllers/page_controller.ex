defmodule TeacExampleWeb.PageController do
  use TeacExampleWeb, :controller

  def home(conn, _params) do
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
        broadcaster_ids: ["1159034889", "27082158"],
        token: Teac.Oauth.ClientCredentialManager.get_token()
      )

    render(conn, :channels_get, channels: channels)
  end

  def channels_patch(conn, _) do
    ident = conn.assigns.current_user.identities |> List.first()

    {:ok, channels} =
      Teac.Api.Channels.patch(
        broadcaster_id: "1159034889",
        token: ident.provider_token,
        form: %{
          "title" => "Building Twitch API Client in Elixir ⚗️",
          "tags" => ["WebDevelopment", "Elixir", "TwitchAPI"],
          "broadcaster_language" => "en",
          "game_id" => "1469308723"
          # "content_classification_labels" => [
          #   %{
          #     "id" => "DebatedSocialIssuesAndPolitics",
          #     "is_enabled" => true
          #   }
          # ],
          # "is_branded_content" => true,
          # "is_rerun" => true
        }
      )

    render(conn, :channels_patch, channels: channels)
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

    render(conn, :chat_badges_get, badges: badges)
  end

  def chat_badges_global_get(conn, _) do
    {:ok, badges} =
      Teac.Api.Chat.Badges.Global.get(token: Teac.Oauth.ClientCredentialManager.get_token())

    render(conn, :chat_badges_global_get, badges: badges)
  end

  def chat_settings_get(conn, _) do
    {:ok, chat} =
      Teac.Api.Chat.Settings.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 27_082_158
      )

    render(conn, :chat_settings_get, chat: chat)
  end

  def chat_messages_post(conn, _) do
    {:ok, chat} =
      Teac.Api.Chat.Messages.post(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 1_159_034_889,
        sender_id: 1_159_034_889,
        message: "YOLO"
      )

    render(conn, :chat_messages_post, chat: chat)
  end

  def chat_color_get(conn, _) do
    {:ok, color} =
      Teac.Api.Chat.Color.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        user_id: "1159034889"
      )

    render(conn, :chat_color_get, color: color)
  end

  def chat_color_put(conn, _) do
    ident = conn.assigns.current_user.identities |> List.first()

    Teac.Api.Chat.Color.put(
      token: ident.provider_token,
      user_id: "1159034889",
      color_label: "green"
    )
    |> dbg()

    render(conn, :chat_color_put)
  end

  def clips_get(conn, _) do
    {:ok, clips} =
      Teac.Api.Clips.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 27_082_158
      )

    render(conn, :clips_get, clips: clips)
  end

  def content_classification_labels_get(conn, _) do
    {:ok, labels} =
      Teac.Api.ContentClassificationLabels.get(
        token: Teac.Oauth.ClientCredentialManager.get_token()
      )

    render(conn, :content_classification_labels_get, labels: labels)
  end

  def games_top_get(conn, _) do
    {:ok, games} =
      Teac.Api.Games.Top.get(token: Teac.Oauth.ClientCredentialManager.get_token()) |> dbg()

    render(conn, :games_top_get, games: games)
  end

  def games_get(conn, _) do
    {:ok, games} =
      Teac.Api.Games.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        names: ["Software and Game Development", "IRL", "Just Chatting"],
        ids: ["27471", "394568"],
        igdb_ids: ["349524"]
      )

    render(conn, :games_get, games: games)
  end

  def schedule_get(conn, _) do
    {:ok, schedule} =
      Teac.Api.Schedule.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        broadcaster_id: 1_159_034_889
      )

    render(conn, :schedule_get, schedule: schedule)
  end

  def search_categories_get(conn, %{"q" => q}) do
    {:ok, categories} =
      Teac.Api.Search.Categories.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        query: q
      )

    render(conn, :search_categories_get, categories: categories)
  end

  def search_categories_get(conn, _) do
    render(conn, :search_categories_get, categories: nil)
  end

  def search_channels_get(conn, %{"q" => q}) do
    {:ok, channels} =
      Teac.Api.Search.Channels.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        query: q
      )

    render(conn, :search_channels_get, channels: channels)
  end

  def search_channels_get(conn, _) do
    render(conn, :search_categories_get, categories: nil)
  end

  def streams_get(conn, _) do
    {:ok, streams} =
      Teac.Api.Streams.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        user_ids: 1_159_034_889
        # user_logins: "lordtocs",
      )
      |> dbg()

    render(conn, :streams_get, streams: streams)
  end

  def users_get(conn, _) do
    {:ok, users} =
      Teac.Api.Users.get(
        token: Teac.Oauth.ClientCredentialManager.get_token(),
        logins: ["lordtocs", "fullstacking", "qiqi_impact", "theprimeagen"]
      )

    render(conn, :users_get, users: users)
  end
end
