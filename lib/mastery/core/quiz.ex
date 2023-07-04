defmodule Mastery.Core.Quiz do
  @moduledoc """
  - title(string): the title of a quiz
  - mastery(integer): the number of questions a user 
    must get right to master a quiz category.
  - current_question(Question.t): the current question being 
    presented to the user.
  - last_reseponse(Response.t): the last response given by user.
  - templates(map): the master list of templates by category.
  - used(list of Template.t): the templates that have benn mastered.
  - record(map of tempate=>integer): the number of correct 
     answers in a row for each template.
  """
  alias Mastery.Core.Quiz
  alias Mastery.Core.Template

  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_reseponse: nil,
            record: %{},
            mastered: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @doc """
  Add template to existing quiz.
  Quite easy to add quiz using function composition.

  ```
  Quiz.new(title: "basic math", mastery: 4)
  |> add_template(fields_for_addition)
  |> add_template(fields_for_subtraction)
  |> add_template(fields_for_multiplication)
  |> add_template(fields_for_division)
  ```
  """
  @spec add_template(Quiz, Template) :: Quiz
  def add_template(quiz, fields) do
    template = Template.new(fields)

    templates =
      update_in(
        quiz.templates,
        [template.category],
        &add_to_list_or_nil(&1, template)
      )

    %{quiz | templates: templates}
  end

  defp add_to_list_or_nil(nil, template), do: [template]
  defp add_to_list_or_nil(templates, template), do: [template | templates]
end
