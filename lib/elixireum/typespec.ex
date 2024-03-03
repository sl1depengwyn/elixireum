defmodule Elixireum.Typespec do
  @type t :: %__MODULE__{
          args: [Blockchain.Type.t()],
          return: Blockchain.Type.t() | nil
        }

  defstruct [:args, :return]
end
