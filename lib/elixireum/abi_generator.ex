defmodule Elixireum.ABIGenerator do
  @moduledoc """
    Responsible for generating Application Binary Interface (ABI).
  """

  alias Elixireum.{Contract, Function}
  alias Blockchain.Type

  @spec generate(Contract.t()) :: map()
  def generate(%Contract{} = contract) do
    Enum.map(contract.functions, &generate_abi_for_elementary/1)
  end

  def generate_abi_for_elementary({name, %Function{} = function}) do
    %{
      name: name,
      type: :function,
      inputs: Enum.zip_with(function.args, function.typespec.args, &arg_to_abi/2),
      outputs:
        (function.typespec.return &&
           Enum.map([function.typespec.return], &arg_to_abi(:output, &1))) || []
    }
  end

  defp arg_to_abi(name, %Type{encoded_type: 3} = arg) do
    %{
      name: name,
      type: arg.abi_name,
      internal_type: arg.abi_name,
      components: Enum.map(arg.components, &arg_to_abi("name_", &1))
    }
  end

  defp arg_to_abi(name, arg) do
    %{name: name, type: arg.abi_name, internal_type: arg.abi_name}
  end
end
