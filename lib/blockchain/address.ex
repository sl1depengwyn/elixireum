defmodule Blockchain.Address do
  @type t() :: %__MODULE__{hash: String.t()}

  defstruct [:hash]

  def load(address_hash) do
    %__MODULE__{hash: address_hash}
  end
end
