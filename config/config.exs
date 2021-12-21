# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pongdom,
  ecto_repos: [Pongdom.Repo]


config :pongdom, Oban,
  repo: Pongdom.Repo,
  plugins: [Oban.Plugins.Pruner, 
  {Oban.Plugins.Cron,
   crontab: [
     {"* * * * *", Pongdom.RequestDispatcherWorker},
   ]}
  ],
  queues: [request_dispatcher: 10, requests: 10, request_asset_dispatcher: 10, request_assets: 10]

config :hammer,
backend: {Hammer.Backend.ETS,
          [ets_table_name: :hammer_backend_ets_buckets,
           expiry_ms: 60_000 * 60 * 2,
           cleanup_interval_ms: 60_000 * 2]}

# Configures the endpoint
config :pongdom, PongdomWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PongdomWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pongdom.PubSub,
  live_view: [signing_salt: "IZhbjjhn"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :pongdom, Pongdom.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.13.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
