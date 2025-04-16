# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :teac,
  mock_units: System.get_env("TWITCH_MOCK_UNITS"),
  client_id: System.get_env("TWITCH_CLIENT_ID"),
  client_secret: System.get_env("TWITCH_CLIENT_SECRET"),
  api_uri: System.get_env("TWITCH_API_URI"),
  auth_uri: System.get_env("TWITCH_AUTH_URI"),
  oauth_callback_uri: System.get_env("TWITCH_OAUTH_CALLBACK_URI")

config :teac_example,
  ecto_repos: [TeacExample.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :teac_example, TeacExampleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TeacExampleWeb.ErrorHTML, json: TeacExampleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TeacExample.PubSub,
  live_view: [signing_salt: "It3RGi6E"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :teac_example, TeacExample.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  teac_example: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  teac_example: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :teac_example, :twitch,
  client_id: System.get_env("TWITCH_CLIENT_ID") || "",
  client_secret: System.get_env("TWITCH_CLIENT_SECRET") || "",
  redirect_uri: System.get_env("TWITCH_REDIRECT_URI") || ""

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
