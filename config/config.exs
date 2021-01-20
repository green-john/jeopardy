# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :jeopardy, JeopardyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eCqU+9Maqw5XQlrtBpKXCaoTanU6FWUKKtR20iuSU/8L1fRdOVQQooV4mwDGcC9d",
  render_errors: [view: JeopardyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jeopardy.PubSub,
  live_view: [signing_salt: "e4ZzZLC2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
