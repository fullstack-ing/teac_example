defmodule TeacExample.Repo.Migrations.CreateUserAuth do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string, null: false
      add :name, :string
      add :confirmed_at, :naive_datetime
      add :active_profile_user_id, references(:users, on_delete: :nilify_all)
      add :avatar_url, :string
      add :description, :text
      timestamps()
    end

    create unique_index(:users, ["lower(email)"], name: :users_email_index)
    create unique_index(:users, ["lower(username)"], name: :users_username_index)

    create table(:identities) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :provider, :string, null: false
      add :provider_token, :string, null: false
      add :provider_login, :string, null: false
      add :provider_email, :string, null: false
      add :provider_id, :string, null: false
      add :provider_meta, :map, default: "{}", null: false

      timestamps()
    end

    create index(:identities, [:user_id])
    create index(:identities, [:provider])
    create unique_index(:identities, [:user_id, :provider])
  end
end
