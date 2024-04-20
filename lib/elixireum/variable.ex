defmodule Elixireum.Variable do
  alias Blockchain.Type

  @type t :: %__MODULE__{
          name: atom(),
          type: Type.t(),
          encoded_name: non_neg_integer(),
          access_keys_types: [Type.t()]
        }

  defstruct [:name, :type, :encoded_name, :access_keys_types]
end
