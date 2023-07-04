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
  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_reseponse: nil,
            record: %{},
            mastered: []
end
