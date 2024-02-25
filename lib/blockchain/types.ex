defmodule Blockchain.Type.Address do
  @behaviour Blockchain.Type

  @type t :: nil

  def size() do
    32
  end
end



for size <-
