defmodule Mastery.Core.Quiz do
  @moduledoc """
  - title(string): the title of a quiz
  - mastery(integer): the number of questions a user 
    must get right to master a quiz category.
  - current_question(Question.t): the current question being 
    presented to the user.
  - last_reseponse(Response.t): the last response given by user.
  - templates(%{cateogory => template[]}): the master list of templates by category.
  - used(list of Template.t): the templates that have benn mastered.
  - record(map of tempate=>integer): the number of correct 
     answers in a row for each template.
  """
  alias Mastery.Core.Question
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

  def select_question(%__MODULE__{templates: t}) when map_size(t) == 0, do: nil

  def select_question(quiz) do
    quiz
    |> pick_current_question
    |> move_template(:used)
    |> reset_template_cycle
  end

  defp pick_current_question(quiz) do
    Map.put(quiz, :current_question, select_a_random_question(quiz))
  end

  def select_a_random_question(quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new()
  end

  defp move_template(quiz, field) do
    quiz
    |> remove_template_from_category
    |> add_template_to_field(field)
  end

  defp template(quiz), do: quiz.current_question.template

  defp remove_template_from_category(quiz) do
    template = template(quiz)

    new_category_templates =
      quiz.templates
      |> Map.fetch!(template.category)
      |> List.delete(template)

    new_templates =
      if new_category_templates == [] do
        Map.delete(
          quiz.templates,
          template.category
        )
      else
        Map.put(
          quiz.templates,
          template.category,
          new_category_templates
        )
      end

    Map.put(quiz, :templates, new_templates)
  end

  defp add_template_to_field(quiz, field) do
    template = template(quiz)
    field_templates = Map.get(quiz, field)

    Map.put(quiz, field, [template | field_templates])
  end

  defp reset_template_cycle(%{templates: templates, used: used} = quiz)
       when map_size(templates) == 0 do
    %__MODULE__{
      quiz
      | templates:
          Enum.group_by(
            used,
            fn template -> template.category end
          ),
        used: []
    }
  end

  defp reset_template_cycle(quiz), do: quiz
end
