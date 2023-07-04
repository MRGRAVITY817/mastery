defmodule Mastery.Core.Template do
  # ~w sigil creates list of strings.
  # with `a` prefix, it will instead create list of atoms.
  defstruct ~w[name category instructions raw compiled generators checker]a
end

