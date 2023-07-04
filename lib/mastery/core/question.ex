defmodule Mastery.Core.Question do
  alias Mastery.Core.Template

  defstruct ~w[asked substitutions template]a

  defp build_substitution({name, choices_or_generator}) do
    {name, choose(choices_or_generator)}
  end

  @doc """
  Choose random question data from given list
  """
  defp choose(choices) when is_list(choices) do
    Enum.random(choices)
  end

  @doc """
  Generate question data
  """
  defp choose(generator) when is_function(generator) do
    generator.()
  end
end
