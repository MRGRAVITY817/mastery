defmodule Mastery.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting Mastery")

    # Telling OTP that these applications should have a generic supervisor.
    # It will start them as singleton process.
    children = [
      {
        Mastery.Boundary.QuizManager,
        [name: Mastery.Boundary.QuizManager]
      },
      {
        Registry,
        [name: Mastery.Registry.QuizSession, keys: :unique]
      },
      {
        Mastery.Boundary.Proctor,
        [name: Mastery.Boundary.Proctor]
      },
      {
        DynamicSupervisor,
        [
          # When this process fails, supervisor will only 
          # restart this process, not others.
          name: Mastery.Supervisor.QuizSession,
          strategy: :one_for_one
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
