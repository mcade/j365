# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :j365,
  ecto_repos: [J365.Repo]

# Configures the endpoint
config :j365, J365.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b+DYc3QZVuDDtZ2+g7fh/y9Hf8wzicmYBRRaA3rk6Um/S2KfQWZtxU7vnrOfWzcL",
  render_errors: [view: J365.ErrorView, accepts: ~w(html json)],
  pubsub: [name: J365.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
