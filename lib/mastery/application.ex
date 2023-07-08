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
        DynamicSupervisor,
        [
          name: Mastery.Supervisor.QuizSession,
          # When this process fails, supervisor will only 
          # restart this process, not others.
          strategy: :one_for_one
          # Sometimes for dependency problem, you might need
          # to restart others, using :rest_for_one.
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
