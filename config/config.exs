# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :simple,
  ecto_repos: [Simple.Repo]

# Configures the endpoint
config :simple, SimpleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ANcO3Kr5Y6FSH9gYua3ryn4ZntCmJ/Wd+AW0LeE3V7vePZqCvPRDlUJIRdId0avI",
  render_errors: [view: SimpleWeb.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: Simple.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :simple, Simple.Guardian,
  issuer: "Simple",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :simple, :corsica_log_level, [rejected: :warn]

config :simple,
  asset_host: System.get_env("CLOUDFRONT_DOMAIN")

config :simple, :cloudex, Cloudex
config :cloudex,
  api_key: System.get_env("CLOUDEX_API_KEY"),
  secret: System.get_env("CLOUDEX_SECRET"),
  cloud_name: System.get_env("CLOUDEX_CLOUD_NAME")

config :ex_twilio, 
  account_sid:   System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token:    System.get_env("TWILIO_AUTH_TOKEN"),
  workspace_sid: System.get_env("TWILIO_WORKSPACE_SID") # optional

# Configures random icon color generator
config :simple, :icon_color_generator, Simple.Helpers.Generator

config :simple, password_reset_timeout: 3600
config :simple, max_requests: 10
config :simple, interval_milliseconds: 60 * 1000

config :simple, Simple.Accounts.RemoveOldGuests,
  jobs: [
    # midnight
    {"@daily",      {Simple.Accounts.RemoveOldGuests, :check_guest_users, []}},
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
