defmodule Blockchain.Storage do
  def get(id) do
    %{yul_snippet: "sload(#{id})", returns_count: 1}
  end

  def store(id, value) do
    %{yul_snippet: "sstore(#{id}, #{value})", returns_count: 0}
  end
end
