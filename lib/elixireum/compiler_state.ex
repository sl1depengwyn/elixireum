defmodule Elixireum.CompilerState do
  alias Elixireum.Variable

  @type t :: %__MODULE__{
          last_return_count: non_neg_integer() | nil,
          declared_variables: MapSet.t(),
          aliases: %{atom() => list()},
          storage_variables: %{atom() => Variable.t()},
          variables: %{atom() => Variable.t()},
          used_standard_functions: %{atom() => t()},
          uniqueness_provider: non_neg_integer(),
          events: %{atom() => Keyword.t()}
        }

  defstruct [
    :aliases,
    last_return_count: nil,
    declared_variables: MapSet.new(),
    storage_variables: %{},
    variables: %{},
    used_standard_functions: %{},
    uniqueness_provider: 0,
    events: %{}
  ]
end
