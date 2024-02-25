defmodule Elixireum.Variable do
  alias Blockchain.Type

  @type t :: %__MODULE__{
          name: String.t(),
          type: Type.t(),
          storage_pointer: non_neg_integer()
        }

  defstruct [:name, :type, :storage_pointer]
end
