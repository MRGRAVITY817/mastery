defmodule MasteryPersistence do
  @moduledoc """
  Documentation for `MasteryPersistence`.
  """
  import Ecto.Query, only: [from: 2]
  alias MasteryPersistence.{Repo, Response}

  def record_response(response, in_transaction \\ fn _response -> :ok end) do
    {:ok, result} =
      Repo.transaction(fn ->
        %{
          quiz_title: to_string(response.quiz_title),
          template_name: to_string(response.template_name),
          to: response.to,
          email: response.email,
          answer: response.correct,
          correct: response.correct,
          inserted_at: response.timestamp,
          updated_at: response.timestamp
        }
        |> Response.record_changeset()
        |> Repo.insert!()

        in_transaction.(response)
      end)

    result
  end
end
