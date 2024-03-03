defmodule Elixireum.AuxiliaryNode do
  @type t :: %__MODULE__{
          type: atom(),
          value: any()
        }

  defstruct [:type, :value]
end
