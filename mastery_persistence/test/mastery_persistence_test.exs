defmodule MasteryPersistenceTest do
  use ExUnit.Case
  alias MasteryPersistence.{Response, Repo}

  describe "Mastery Persistence Layer" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

      response = %{
        quiz_title: :simple_addition,
        template_name: :single_digit_addition,
        to: "3 + 4",
        email: "student@example.com",
        answer: "7",
        correct: true,
        timestamp: DateTime.utc_now()
      }

      {:ok, %{response: response}}
    end
  end
end
