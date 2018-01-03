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

config :simple, 
  postmark_early_access_template: "123"

config :simple, Simple.Mailer,
  adapter: Bamboo.TestAdapter

# Set Corsica logging to output no console warning when rejecting a request
config :simple, :corsica_log_level, [rejected: :debug]