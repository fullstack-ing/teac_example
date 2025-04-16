defmodule TeacExample.TwitchWssClient do
  use WebSockex
  require Logger

  @wss_endpoint "wss://eventsub.wss.twitch.tv/ws?keepalive_timeout_seconds=30"

  def start_link(opts) do
    WebSockex.start_link(
      @wss_endpoint,
      __MODULE__,
      opts
    )
  end

  def init(state) do
    Logger.info("Successfully ~authenticated and connected.")
    {:ok, state}
  end

  @impl true
  def handle_connect(_conn, state) do
    send(state.liveview_pid, {:twitch_socket_connected, :ok})
    Logger.info("Successfully connected to twitch websocket")
    {:ok, state}
  end

  @impl true
  def handle_frame({_type, msg}, state) do
    case JSON.decode(msg) do
      {:ok, data} ->
        data
        |> maybe_handle_welcome(state)
        |> maybe_handle_chat_message(state)
        |> maybe_handle_announcement(state)

      {:error, reason} ->
        Logger.error("Failed to decode JSON: #{inspect(reason)}")
    end

    {:ok, state}
  end

  def maybe_handle_welcome(
        %{
          "metadata" => %{"message_type" => "session_welcome"},
          "payload" => %{"session" => %{"id" => session_id}}
        } = data,
        state
      ) do
    params = [
      token: state.access_token,
      client_id: Application.get_env(:teac, :client_id),
      payload: %{
        "type" => "channel.chat.message",
        "version" => "1",
        "condition" => %{
          "broadcaster_user_id" => "1159034889",
          "user_id" => "1159034889"
        },
        "transport" => %{
          "method" => "websocket",
          "session_id" => session_id
        }
      }
    ]

    params2 = [
      token: state.access_token,
      client_id: Application.get_env(:teac, :client_id),
      payload: %{
        "type" => "channel.chat.notification",
        "version" => "1",
        "condition" => %{
          "broadcaster_user_id" => "1159034889",
          "user_id" => "1159034889"
        },
        "transport" => %{
          "method" => "websocket",
          "session_id" => session_id
        }
      }
    ]

    case Teac.Api.EventSub.Subscriptions.post(params) do
      {:ok, _} ->
        Logger.info("Successfully recived welcome message and subscribed to channel.chat.message")
        send(state.liveview_pid, {:twitch_welcome, :ok})

      _ ->
        Logger.error("Issue with welcome message")
    end

    Teac.Api.EventSub.Subscriptions.post(params2)

    data
  end

  def maybe_handle_welcome(data, _state) do
    data
    |> dbg()
  end

  def maybe_handle_chat_message(
        %{
          "metadata" => %{
            "message_timestamp" => _message_timestamp,
            "message_type" => "notification",
            "subscription_type" => "channel.chat.message"
          },
          "payload" => payload
        },
        state
      ) do
    send(state.liveview_pid, {:twitch_chat_msg, payload})
  end

  def maybe_handle_chat_message(data, _state) do
    data
  end

  def maybe_handle_announcement(
        %{
          "metadata" => %{
            "message_id" => "F3P7kLZV3N9r4Nd68twadXppuym1wprfLorXWVdOrao=",
            "message_timestamp" => _message_timestamp,
            "message_type" => "notification",
            "subscription_type" => "channel.chat.notification"
          },
          "payload" => payload
        },
        state
      ) do
    send(state.liveview_pid, {:twitch_chat_announcement, payload})
  end

  def maybe_handle_announcement(data, _state) do
    data
  end
end
