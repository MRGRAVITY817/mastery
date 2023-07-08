defmodule Mastery.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting Mastery")

    # Telling OTP that these applications should have a generic supervisor.
    # It will start them as singleton process.
    children = [
      # We're adding QuizManager into process Registry
      {Mastery.Boundary.QuizManager, [name: Mastery.Boundary.QuizManager]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
