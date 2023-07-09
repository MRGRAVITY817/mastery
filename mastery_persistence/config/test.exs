import Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "mastery_test",
  hostname: "localhost",
  username: "postgres",
  password: "postgres"
  # this can speed up our test
  pool: Ecto.Adapters.SQL.Sandbox
