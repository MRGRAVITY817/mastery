defmodule QuizTest do
  use ExUnit.Case
  use QuizBuilders

  # Test Helper Methods

  # Pick different template from given template.
  defp eventually_pick_other_template(quiz, template) do
    Stream.repeatedly(fn ->
      Quiz.select_question(quiz).current_question.template
    end)
    |> Enum.find(fn other -> other != template end)
  end

  # Get the template of the quiz.
  defp template(quiz) do
    quiz.current_question.template
  end

  defp right_answer(quiz), do: answer_question(quiz, "3")
  defp wrong_answer(quiz), do: answer_question(quiz, "wrong")

  defp answer_question(quiz, answer) do
    email = "mathy@example.com"
    response = Response.new(quiz, email, answer)
    Quiz.answer_question(quiz, response)
  end

  # Text Context Fixture

  defp quiz(context) do
    {:ok, Map.put(context, :quiz, build_quiz_with_two_templates())}
  end

  defp quiz_always_adds_one_and_two(context) do
    fields = template_fields(generators: addition_generators([1], [2]))

    quiz =
      build_quiz(mastery: 2)
      |> Quiz.add_template(fields)

    {:ok, Map.put(context, :quiz, quiz)}
  end
end
