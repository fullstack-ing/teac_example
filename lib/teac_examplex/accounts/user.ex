defmodule TeacExample.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias TeacExample.Accounts.Identity

  schema "users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :confirmed_at, :naive_datetime
    field :active_profile_user_id, :id
    field :avatar_url, :string
    field :description, :string
    has_many :identities, Identity

    timestamps()
  end

  @doc """
  A user changeset for twitch registration.
  """
  def twitch_registration_changeset(info, primary_email, emails, token) do
    %{"login" => username, "profile_image_url" => avatar_url, "description" => description} = info
    # %{
    #   "access_token_expires_in" => 14699,
    #   "broadcaster_type" => "",
    #   "created_at" => "2024-10-10T17:18:49Z",
    #   "description" => "I write code, (Elixir, Rust, Python, JS), Sometimes I game, Rarely I \"make\" music. ",
    #   "display_name" => "DeadEgos",
    #   "email" => "40hzshadow@gmail.com",
    #   "id" => "1159034889",
    #   "login" => "deadegos",
    #   "offline_image_url" => "https://static-cdn.jtvnw.net/jtv_user_pictures/44df48a5-52bd-4c50-8fbd-bb2e0203841e-channel_offline_image-1920x1080.png",
    #   "profile_image_url" => "https://static-cdn.jtvnw.net/jtv_user_pictures/59d1301a-288d-4cc3-9e24-f0b14453abcb-profile_image-300x300.png",
    #   "refresh_token" => "",
    #   "type" => ""
    # }

    identity_changeset =
      Identity.twitch_registration_changeset(info, primary_email, emails, token)

    if identity_changeset.valid? do
      params = %{
        "username" => username,
        "email" => primary_email,
        "name" => get_change(identity_changeset, :provider_name),
        "avatar_url" => avatar_url,
        "description" => description
      }

      %User{}
      |> cast(params, [:email, :name, :username, :avatar_url, :description])
      |> validate_required([:email, :name, :username])
      |> validate_username()
      |> validate_email()
      |> put_assoc(:identities, [identity_changeset])
    else
      %User{}
      |> change()
      |> Map.put(:valid?, false)
      |> put_assoc(:identities, [identity_changeset])
    end
  end

  def settings_changeset(%User{} = user, params) do
    user
    |> cast(params, [:username, :profile_tagline])
    |> validate_required([:username, :profile_tagline])
    |> validate_username()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> update_change(:email, &String.downcase/1)
    |> unsafe_validate_unique(:email, TeacExample.Repo)
    |> unique_constraint(:email)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_format(:username, ~r/^[a-zA-Z0-9_-]{2,32}$/)
    |> unsafe_validate_unique(:username, TeacExample.Repo)
    |> unique_constraint(:username)
  end
end
