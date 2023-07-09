defmodule MasteryPersistence.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MasteryPersistence.Repo
    ]

    opts = [strategy: :one_for_one, name: MasteryPersistence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
