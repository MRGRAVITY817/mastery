Code.require_file("support/quiz_builders.exs", __DIR__)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(MasteryPersistence.Repo, :manual)
