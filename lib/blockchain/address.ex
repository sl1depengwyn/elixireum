defmodule Blockchain.Address do
  @type t() :: %__MODULE__{hash: String.t()}

  defstruct [:hash]

  def load("0x" <> <<hex::binary-size(40)>> = address_hash) do
    case Base.decode16(hex, case: :mixed) do
      {:ok, _} ->
        {:ok, %__MODULE__{hash: address_hash}}

      :error ->
        :error
    end
  end

  def load(_address_hash) do
    :error
  end
end
