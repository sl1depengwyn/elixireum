defmodule Elixireum.Library.Utils do
  require Integer

  alias Blockchain.Address
  alias Elixireum.Library.Arithmetic
  alias Elixireum.YulNode

  @methods %{
    {Kernel, :+} => &Arithmetic.add/4,
    :+ => &Arithmetic.add/4
  }

  def method_atom_to_yul(method) do
    case Map.fetch(@methods, method) do
      {:ok, fun} ->
        fun

      :error ->
        :error
    end
  end

  def literal_to_bytes(integer) when is_integer(integer) do
    hex_name = Integer.to_string(integer, 16)

    if hex_name |> String.length() |> Integer.is_even() do
      hex_name
    else
      "0" <> hex_name
    end
  end

  def literal_to_bytes(string) when is_binary(string) do
    # TODO
  end

  def literal_to_bytes(%Address{hash: "0x" <> hash}), do: hash

  def load_value(%YulNode{}) do
    """

    """
  end

  def store_value(%YulNode{}) do
  end
end
