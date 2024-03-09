defmodule Elixireum.Contract do
  alias Elixireum.{Functions, Variable}

  @type t :: %__MODULE__{
          functions: Functions.t(),
          name: String.t(),
          private_functions: Functions.t(),
          variables: %{atom() => Variable.t()},
          aliases: %{atom() => list()}
        }

  defstruct [:functions, :name, :private_functions, :variables, :aliases]
end
