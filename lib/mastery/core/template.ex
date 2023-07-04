defmodule Mastery.Core.Template do
  @moduledoc ~S"""
  - name(atom): the name of the template
  - category(atom): a grouping for questions of the same name
  - instructions(string): description that tells user how to answer the question.
  - raw(string): the template code before compilation
  - compiled(macro): the compiled version of the template code.
  - generators(map of list/function): list of function that can be used to 
                                      generate the values in template blanks.
  - checker(function): checks if the answer is correct.
  """

  # ~w sigil creates list of strings.
  # with `a` prefix, it will instead create list of atoms.
  defstruct ~w[name category instructions raw compiled generators checker]a

  def new(fields) do
    raw = Keyword.fetch!(fields, :raw)

    struct!(
      __MODULE__,
      Keyword.put(fields, :compiled, EEx.compile_string(raw))
    )
  end
end

