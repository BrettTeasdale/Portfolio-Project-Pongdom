import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

config :pongdom, Oban,
  repo: Pongdom.Repo,
  plugins: false,
  queues: false


config :pongdom, ObanWeb, stats: false


# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pongdom, Pongdom.Repo,
  username: "dbuser",
  password: "dbpassword",
  database: "pongdom_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pongdom, PongdomWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mpDzhxJd5MTQ2707OVdRCpJS7PHIId8Wj5Psb67LyWdcVw6k2axgzj3wOSo8hHGE",
  server: false

# In test we don't send emails.
config :pongdom, Pongdom.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
