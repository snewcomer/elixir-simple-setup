use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :simple, SimpleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :simple, Simple.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "simple_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :simple, allowed_origins: ["http://localhost:4200"]

config :simple, site_url: "http://localhost:4200"

config :simple, Simple.Guardian,
  secret_key: "e62fb6e2746f6b1bf8b5b735ba816c2eae1d5d76e64f18f3fc647e308b0c159e"

config :simple, 
  postmark_forgot_password_template: "123",
  postmark_reply_to_conversation_template: "123"

config :ex_twilio, 
  account_sid:   System.get_env("TWILIO_ACCOUNT_TEST_SID"),
  auth_token:    System.get_env("TWILIO_TEST_AUTH_TOKEN"),
  workspace_sid: System.get_env("TWILIO_WORKSPACE_SID") # optional

config :simple, Simple.Mailer,
  adapter: Bamboo.TestAdapter

config :jsonapi,
  underscore_to_dash: true,
  remove_links: true

config :bcrypt_elixir, log_rounds: 4

config :simple, :icon_color_generator, Simple.Helpers.TestGenerator
config :simple, max_requests: 1000

# Set Corsica logging to output no console warning when rejecting a request
config :simple, :corsica_log_level, [rejected: :debug]