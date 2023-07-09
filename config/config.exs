import Config

config :mastery_persistence, ecto_repos: [MasteryPersistence.Repo]

config :logger, level: :info

import_config "#{config_env()}.exs"
