defmodule Elixireum.YulNode do
  @type t :: %__MODULE__{
          yul_snippet: String.t(),
          meta: any(),
          return_values_count: non_neg_integer(),
          elixir_initial: Macro.t()
        }

  @enforce_keys [:yul_snippet, :return_values_count, :elixir_initial]
  defstruct [:yul_snippet, :meta, :return_values_count, :elixir_initial]
end
