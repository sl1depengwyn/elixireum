defmodule Elixireum.YulNode do
  @type t :: %__MODULE__{
          yul_snippet_definition: String.t(),
          yul_snippet_usage: String.t(),
          meta: any(),
          return_values_count: non_neg_integer(),
          elixir_initial: Macro.t(),
          value: any(),
          var: boolean()
        }

  @enforce_keys [:return_values_count, :elixir_initial]
  defstruct [
    :meta,
    :return_values_count,
    :elixir_initial,
    :yul_snippet_usage,
    :value,
    var: false,
    yul_snippet_definition: ""
  ]
end
