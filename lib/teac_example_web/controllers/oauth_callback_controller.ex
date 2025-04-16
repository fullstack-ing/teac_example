defmodule TeacExampleWeb.OAuthCallbackController do
  use TeacExampleWeb, :controller
  require Logger

  # alias TeacExampleWeb.Accounts

  def new(conn, %{"provider" => "twitch", "code" => code, "state" => state}) do
    client = twitch_client(conn)

    # Get token
    {:ok,
     %{
       "access_token" => access_token,
       "expires_in" => access_token_expires_in,
       "refresh_token" => refresh_token
     }} = client.exchange_code_for_token(code: code, state: state)

    {:ok,
     [
       %{
         "broadcaster_type" => broadcaster_type,
         "created_at" => created_at,
         "description" => description,
         "display_name" => display_name,
         "email" => email,
         "id" => twitch_id,
         "login" => twitch_login,
         "offline_image_url" => offline_image_url,
         "profile_image_url" => profile_image_url,
         "type" => twitch_type
       }
     ]} =
      Teac.Api.Users.get(
        client_id: Application.get_env(:teac, :client_id),
        token: access_token
      )

    info = %{
      "broadcaster_type" => broadcaster_type,
      "created_at" => created_at,
      "description" => description,
      "display_name" => display_name,
      "email" => email,
      "id" => twitch_id,
      "login" => twitch_login,
      "offline_image_url" => offline_image_url,
      "profile_image_url" => profile_image_url,
      "type" => twitch_type,
      "access_token_expires_in" => access_token_expires_in,
      "refresh_token" => refresh_token
    }

    {:ok, user} = TeacExample.Accounts.register_twitch_user(email, info, [email], access_token)

    conn
    |> put_flash(:info, "Welcome #{user.username}")
    |> TeacExampleWeb.UserAuth.log_in_user(user)
  end

  def new(conn, %{"provider" => "twitch", "error" => "access_denied"}) do
    redirect(conn, to: "/")
  end

  def sign_out(conn, _) do
    TeacExampleWeb.UserAuth.log_out_user(conn)
  end

  defp twitch_client(conn) do
    conn.assigns[:twitch_client] || TeacExample.TwitchOAuthClient
  end
end
