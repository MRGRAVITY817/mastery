defmodule Mastery.Boundary.QuizValidator do
  alias Mastery.Boundary.Validator, as: V

  def errors(fields) when is_map(fields) do
    []
    |> V.require(fields, :title, &validate_title/1)
    |> V.optional(fields, :mastery, &validate_mastery/1)
  end

  def errors(_fields), do: [{nil, "A map of fields is required"}]

  def validate_title(title) when is_binary(title) do
    V.check(String.match?(title, ~r{\S}), {:error, "can't be blank"})
  end

  def validate_title(_title), do: {:error, "must be a string"}

  def validate_mastery(mastery) when is_integer(mastery) do
    V.check(mastery >= 1, {:error, "must be greater than zero"})
  end

  def validate_mastery(_mastery), do: {:error, "must be an integer"}
end
