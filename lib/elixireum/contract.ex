defmodule Elixireum.Contract do
  alias Elixireum.{Event, Functions, Variable}

  @type t :: %__MODULE__{
          functions: Functions.t(),
          name: String.t(),
          private_functions: Functions.t(),
          variables: %{atom() => Variable.t()},
          events: %{atom() => Event.t()},
          aliases: %{atom() => list()}
        }

  defstruct [:functions, :name, :private_functions, :variables, :events, :aliases]
end
