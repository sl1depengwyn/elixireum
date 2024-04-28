defmodule Elixireum.Event do
  alias Blockchain.Type

  @type t :: %__MODULE__{
          name: atom(),
          indexed_arguments: [keyword(Type.t())],
          arguments: [keyword(Type.t())]
        }

  defstruct [:name, :indexed_arguments, :arguments]

  def emit(%__MODULE__{name: name, indexed_arguments: indexed_arguments, arguments: arguments}, state, node) do
    for {key, type} <- indexed_arguments do

    end
  end

  defp encode_indexed_argument(arg) do
    
  end
end
