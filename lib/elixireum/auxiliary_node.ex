defmodule Elixireum.AuxiliaryNode do
  @type t :: %__MODULE__{
          type: atom(),
          value: any(),
          access_keys: list()
        }

  defstruct [:type, :value, access_keys: []]
end
