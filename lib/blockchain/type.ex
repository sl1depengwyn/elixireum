defmodule Blockchain.Type do
  @callback size() :: integer() | :dynamic
end
