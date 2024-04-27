defmodule Blockchain.Storage do
  alias Blockchain.Type
  alias Elixireum.{CompilerState, Variable, YulNode}
  alias Elixireum.Library.Utils

  def get(
        %Variable{} = variable,
        access_keys,
        %CompilerState{uniqueness_provider: uniqueness_provider} = state,
        node
      ) do
    # somehow check that variable + access_keys points to a single word in storage, i.e. if variable is string[][] access keys must be [uint, uint]

    {definition, slot, keys_definition} = keccak_from_var_and_access_keys(variable, access_keys)

    var_name = "$storage_get$#{uniqueness_provider}$"

    definition =
      """
      #{keys_definition}
      #{definition}
      let #{var_name} := offset$
      mstore8(offset$, #{variable.type.encoded_type})
      mstore(add(1, offset$), sload(#{slot}))
      //offset$ := add(offset$, 1)
      offset$ := add(offset$, #{variable.type.size + 1})
      """

    {%YulNode{
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: node,
       yul_snippet_definition: definition
     }, %CompilerState{state | uniqueness_provider: uniqueness_provider + 1}}
  end

  def store(
        %Variable{} = variable,
        access_keys,
        %YulNode{} = value,
        %CompilerState{} = state,
        node
      ) do
    {definition, slot, keys_definition} = keccak_from_var_and_access_keys(variable, access_keys)

    definition =
      """
      #{value.yul_snippet_definition}
      #{keys_definition}
      #{definition}
      """

    {%YulNode{
       elixir_initial: node,
       meta: value.meta,
       yul_snippet_definition: definition,
       yul_snippet_usage: "sstore(#{slot}, mload(add(#{value.yul_snippet_usage}, 1)))",
       return_values_count: 0
     }, state}
  end

  defp keccak_from_var_and_access_keys(variable, access_keys) do
    if Enum.all?(access_keys, &(not is_nil(&1.value))) do
      slot =
        "#{Utils.literal_to_bytes(variable.encoded_name)}#{Enum.reduce(access_keys, "", fn key, acc -> acc <> Utils.literal_to_bytes(key.value) end)}"
        |> Base.decode16!(case: :mixed)
        |> ExKeccak.hash_256()
        |> Base.encode16(case: :lower)

      {"", "0x" <> slot, ""}
    else
      {definition, keccak_size, keys_definition} =
        access_keys
        |> Enum.zip(variable.access_keys_types)
        |> Enum.reduce(
          {"""
           mstore(offset$, #{variable.encoded_name})
           offset$ := add(offset$, 32)
           """, 32, ""},
          fn {key, type}, {yul_acc, keccak_size_acc, keys_definition_acc} ->
            if is_nil(key.value) do
              {yul_acc <>
                 """
                 switch byte(0, mload(#{key.yul_snippet_usage}))
                   case #{type.encoded_type} {}
                   default {revert(0, 0)}

                 mstore(offset$, mload(add(1, #{key.yul_snippet_usage})))
                 offset$ := add(offset$, #{type.size})
                 """, keccak_size_acc + type.size,
               keys_definition_acc <> "\n" <> key.yul_snippet_definition}
            else
              if Type.elixir_to_encoded_type(key) != type.encoded_type do
                raise "wrong access key type"
              end

              {yul_acc <>
                 """
                 mstore(offset$, #{key.value})
                 offset$ := add(offset$, #{type.size})
                 """, keccak_size_acc + type.size, keys_definition_acc}
            end
          end
        )

      {definition, "keccak256(sub(offset$, #{keccak_size}), #{keccak_size})", keys_definition}
    end
  end
end
