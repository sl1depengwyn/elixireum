defmodule Elixireum.Library.Utils do
  alias Elixireum.Library.Arithmetic

  @methods %{
    +: &Arithmetic.add/4
  }

  def method_atom_to_yul(method) do
    case Map.fetch(@methods, method) do
      {:ok, fun} ->
        fun

      :error ->
        :error
    end
  end
end
