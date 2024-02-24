defmodule Blockchain.Storage do
  def get(id) do
    "sload(#{id})"
  end

  def store(id, value) do
    "sstore(#{id}, #{value})"
  end
end
