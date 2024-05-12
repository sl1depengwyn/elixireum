defmodule Elixireum.Yul.StdFunction do
  @type t :: %__MODULE__{
          deps: %{atom() => t()},
          yul: String.t()
        }

  @enforce_keys [:yul]

  defstruct [:yul, deps: %{}]
end
