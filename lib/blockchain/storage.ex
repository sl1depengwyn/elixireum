defmodule Blockchain.Storage do
  # TODO add mstore
  def get(id) do
    %{yul_snippet_usage: "sload(#{id})", return_values_count: 1}
  end

  def store(id, value) do
    %{yul_snippet_usage: "sstore(#{id}, #{value})", return_values_count: 0}
  end
end
