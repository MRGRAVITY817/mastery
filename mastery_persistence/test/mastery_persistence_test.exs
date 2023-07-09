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

      # test context
      {:ok, %{response: response}}
    end

    test "responses are recorded", %{response: response} do
      assert Repo.aggregate(Response, :count, :id) == 0
      assert :ok == MasteryPersistence.record_response(response)

      assert Repo.all(Response)
             |> Enum.map(fn r -> r.email end) == [response.email]
    end
  end
end
