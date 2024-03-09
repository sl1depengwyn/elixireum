defmodule Elixireum.CompilerState do
  @type t :: %__MODULE__{
          last_return_count: non_neg_integer() | nil,
          declared_variables: MapSet.t(),
          aliases: %{atom() => list()},
          storage_variables: %{atom() => Variable.t()}
        }

  @enforce_keys [:aliases]

  defstruct [
    :aliases,
    last_return_count: nil,
    declared_variables: MapSet.new(),
    storage_variables: %{}
  ]
end
