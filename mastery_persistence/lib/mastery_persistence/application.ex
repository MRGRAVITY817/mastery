defmodule MasteryPersistence.Application do
  @moduledoc false

  use Application

  use Ecto.Repo,
    otp_app: :mastery_persistence,
    adapter: Ecto.Adapters.Postgres

  @impl true
  def start(_type, _args) do
    children = [
      MasteryPersistence.Repo
    ]

    opts = [strategy: :one_for_one, name: MasteryPersistence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
