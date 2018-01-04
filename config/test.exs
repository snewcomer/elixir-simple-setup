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

config :simple, Simple.Guardian,
  secret_key: "e62fb6e2746f6b1bf8b5b735ba816c2eae1d5d76e64f18f3fc647e308b0c159e"

config :simple, 
  postmark_early_access_template: "123"

config :simple, Simple.Mailer,
  adapter: Bamboo.TestAdapter

config :jsonapi,
  underscore_to_dash: true,
  remove_links: true

config :bcrypt_elixir, log_rounds: 4

# Set Corsica logging to output no console warning when rejecting a request
config :simple, :corsica_log_level, [rejected: :debug]