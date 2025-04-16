defmodule TeacExampleWeb.TwitchLive do
  use TeacExampleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="sm:flex">
      <div class="mb-4 shrink-0 sm:mr-4 sm:mb-0">
        <img src={@current_user.avatar_url} class="h-16 w-16" />
      </div>
      <div>
        <h4 class="text-lg font-bold">
          {@current_user.username}
        </h4>
        <p class="mt-1">
          {@current_user.description}
        </p>
      </div>
    </div>

    <hr class="my-10" />

    <div class="mb-8">
      <.button :if={!@twitch_socket_connected} phx-click="start_socket">
        Join Chat
      </.button>
      <div :if={@twitch_socket_connected}>
        <span class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-green-600/20 ring-inset">
          Socket Connected
        </span>
        <span
          if={@twitch_socket_welcome}
          class="inline-flex items-center rounded-md bg-indigo-400/10 px-2 py-1 text-xs font-medium text-indigo-400 ring-1 ring-indigo-400/30 ring-inset"
        >
          Listening to: channel.chat.message events
        </span>
      </div>
      <div :if={@twitch_socket_welcome} class="mt-6">
        <div class="mt-8">
          <h4 class="mb-2">Chat:</h4>
          <p :for={
            %{
              "event" => %{
                "chatter_user_name" => chatter_user_name,
                "color" => color,
                "message" => msg
              }
            } <-
              @twitch_chat_msgs
          }>
            <span class="font-bold" style={"color: #{color};"}>{chatter_user_name}</span>: {raw(msg)}
          </p>
        </div>
      </div>
    </div>

    <div class="bg-zinc-100 shadow sm:rounded-lg mb-4">
      <div class="px-4 py-5 sm:p-6">
        <h3 class="text-base font-semibold text-gray-900">Send Chat Message</h3>

        <.simple_form for={@form} phx-submit="send_message" phx-change="validate" id="chat-form">
          <div class="field">
            <.input
              type="textarea"
              field={@form[:message]}
              placeholder="Type your message..."
              phx-debounce="300"
              maxlength="500"
            />
            <.input
              field={@form[:announcements]}
              type="select"
              prompt="Non Announcement"
              options={[:green, :orange, :purple, :blue, :primary]}
            />
          </div>

          <:actions>
            <.button
              class="inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              phx-disable-with="Saving..."
            >
              Post
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(%{"message" => ""})

    {:ok,
     assign(socket,
       form: form,
       twitch_socket_connected: false,
       twitch_socket_welcome: false,
       twitch_chat_msgs: []
     )}
  end

  def handle_event("validate", %{"message" => message, "announcements" => announcements}, socket) do
    form = to_form(%{"message" => message, "announcements" => announcements})
    {:noreply, assign(socket, form: form)}
  end

  def handle_event(
        "send_message",
        %{"message" => message, "announcements" => announcements},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    # Process your message here (message is already limited to 500 chars)
    # Clear the input after sending
    ident = current_user.identities |> List.first()

    if announcements == "" do
      Teac.Api.Chat.Messages.post(
        token: ident.provider_token,
        client_id: Application.get_env(:teac, :client_id),
        broadcaster_id: ident.provider_id,
        sender_id: ident.provider_id,
        message: message
      )
    else
      Teac.Api.Chat.Announcements.post(
        token: ident.provider_token,
        client_id: Application.get_env(:teac, :client_id),
        broadcaster_id: ident.provider_id,
        moderator_id: ident.provider_id,
        sender_id: ident.provider_id,
        color: announcements,
        message: message
      )
    end

    form = to_form(%{"message" => "", "announcements" => nil})

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("start_socket", _params, %{assigns: %{current_user: current_user}} = socket) do
    ident = current_user.identities |> List.first()
    start_twitch_socket(ident.provider_token, self())
    {:noreply, socket}
  end

  def handle_info({:twitch_event, data}, socket) do
    {:noreply, assign(socket, twitch_data: data)}
  end

  def handle_info({:twitch_socket_connected, :ok}, socket) do
    {:noreply, assign(socket, twitch_socket_connected: true)}
  end

  def handle_info({:twitch_welcome, :ok}, socket) do
    {:noreply, assign(socket, twitch_socket_welcome: true)}
  end

  def handle_info(
        {:twitch_chat_msg, msg},
        %{assigns: %{twitch_chat_msgs: twitch_chat_msgs}} = socket
      ) do
    %{
      "event" => %{
        "chatter_user_name" => chatter_user_name,
        "color" => color
      }
    } = msg

    {:noreply,
     assign(socket,
       twitch_chat_msgs:
         twitch_chat_msgs ++
           [
             %{
               "event" => %{
                 "chatter_user_name" => chatter_user_name,
                 "color" => color,
                 "message" => process_fragments(msg)
               }
             }
           ]
     )}
  end

  def handle_info(
        {:twitch_chat_announcement, msg},
        %{assigns: %{twitch_chat_msgs: twitch_chat_msgs}} = socket
      ) do
    %{
      "event" => %{
        "chatter_user_name" => chatter_user_name,
        "color" => color
      }
    } = msg

    {:noreply,
     assign(socket,
       twitch_chat_msgs:
         twitch_chat_msgs ++
           [
             %{
               "event" => %{
                 "chatter_user_name" => chatter_user_name,
                 "color" => color,
                 "message" => msg
               }
             }
           ]
     )}
  end

  def start_twitch_socket(access_token, liveview_pid) do
    DynamicSupervisor.start_child(
      TeacExample.TwitchWssClientSupervisor,
      {TeacExample.TwitchWssClient, %{access_token: access_token, liveview_pid: liveview_pid}}
    )
  end

  defp process_fragments(msg) do
    msg["event"]["message"]["fragments"]
    |> Enum.map(fn
      %{"type" => "emote", "emote" => emote} ->
        %{"id" => id, "format" => format} = emote

        format = if Enum.member?(format, "animated"), do: "default", else: "static"

        """
        <img class="inline" src="https://static-cdn.jtvnw.net/emoticons/v2/#{id}/#{format}/dark/1.0"/>
        """

      %{"type" => "text", "text" => text} ->
        text

      frag ->
        frag
    end)
    |> List.to_string()
    |> dbg()
  end
end
