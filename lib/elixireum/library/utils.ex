defmodule Elixireum.Library.Utils do
  require Integer

  alias Blockchain.{Address, Event, Storage}
  alias Elixireum.Library.{Arithmetic, Comparison}
  alias Elixireum.{Compiler, CompilerState, YulNode}

  @methods %{
    {Kernel, :+} => &Arithmetic.add/4,
    :+ => &Arithmetic.add/4,
    :- => &Arithmetic.sub/4,
    {[:Blockchain, :Storage], :store} => &Storage.store/4,
    {[:Blockchain, :Storage], :get} => &Storage.get/3,
    {[:Blockchain], :tx_origin} => &Blockchain.tx_origin/2,
    {[:Blockchain], :caller} => &Blockchain.caller/2,
    :raise => &Blockchain.revert/3,
    {[:Blockchain, :Event], :emit} => &Event.emit/4,
    :== => &Comparison.equal?/4,
    :< => &Comparison.less?/4,
    :> => &Comparison.greater?/4,
  }

  def function_call_to_yul(method) do
    case Map.fetch(@methods, method) do
      {:ok, fun} ->
        fun

      :error ->
        :not_found
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

  def generate_revert(error_message, uniqueness_provider) do
    {err_yul_node, _state} =
      Compiler.expand_expression(error_message, %CompilerState{
        uniqueness_provider: uniqueness_provider
      })

    err_message_ptr = "$err_message_ptr#{uniqueness_provider}"
    err_message_size = "$err_message_size#{uniqueness_provider}"

    """
    #{err_yul_node.yul_snippet_definition}
    let #{err_message_ptr} := add(1, #{err_yul_node.yul_snippet_usage})
    let #{err_message_size} := mload(#{err_message_ptr})
    #{err_message_ptr} := add(#{err_message_ptr}, 32)
    revert(#{err_message_ptr}, #{err_message_size})
    """
  end

  def generate_type_check(yul_snippet_usage, expected_type, error_message, uniqueness_provider) do
    """
    switch byte(0, mload(#{yul_snippet_usage}))
    case #{expected_type} {}
    default {
      #{generate_revert(error_message, uniqueness_provider)}
    }
    """
  end

  def generate_value_check(yul_snippet_usage, expected_value, error_message, uniqueness_provider) do
    """
    switch #{yul_snippet_usage}
    case #{expected_value} {}
    default {
      #{generate_revert(error_message, uniqueness_provider)}
    }
    """
  end
end
