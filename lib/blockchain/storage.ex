defmodule Blockchain.Storage do
  alias Blockchain.Type
  alias Elixireum.{AuxiliaryNode, CompilerState, Variable, YulNode}
  alias Elixireum.Library.Utils

  def get(
        %AuxiliaryNode{
          type: :storage_variable,
          value: %Variable{type: %Type{encoded_type: 1}} = variable,
          access_keys: access_keys
        },
        %CompilerState{uniqueness_provider: uniqueness_provider} = state,
        node
      ) do
    {slot_definition, slot, keys_definition} = keccak_from_var_and_access_keys(variable, access_keys, state)

    slot_end_var_name = "storage_i_#{state.uniqueness_provider}$end"
    size_var_name = "str_size$#{state.uniqueness_provider}$"
    slot_var_name = "slot_storage#{state.uniqueness_provider}$"

    var_name = "$storage_get$#{uniqueness_provider}$"

    definition =
      """
      let #{var_name} := offset$

      #{keys_definition}
      #{slot_definition}

      mstore8(offset$, #{variable.type.encoded_type})
      offset$ := add(offset$, 1)

      let #{slot_var_name} := #{slot}
      let #{size_var_name} := sload(#{slot_var_name})
      #{slot_var_name} := add(#{slot_var_name}, 1)
      let #{slot_end_var_name} := add(#{slot_var_name}, add(1, div(sub(#{size_var_name}, 1), 32)))

      mstore(offset$, #{size_var_name})
      offset$ := add(offset$, 32)

       for { } lt(#{slot_var_name}, #{slot_end_var_name})
       {
         offset$ := add(offset$, 32)
         #{slot_var_name} := add(#{slot_var_name}, 1)
       }
       {
        mstore(offset$, sload(#{slot_var_name}))
       }
      """

    {%YulNode{
       elixir_initial: node,
       yul_snippet_definition: definition,
       yul_snippet_usage: var_name,
       return_values_count: 1
     }, %CompilerState{state | uniqueness_provider: state.uniqueness_provider + 1}}
  end

  def get(
        %AuxiliaryNode{
          type: :storage_variable,
          value: variable,
          access_keys: access_keys
        },
        %CompilerState{uniqueness_provider: uniqueness_provider} = state,
        node
      ) do
    # somehow check that variable + access_keys points to a single word in storage, i.e. if variable is string[][] access keys must be [uint, uint]
        dbg(variable)
    {definition, slot, keys_definition} =
      keccak_from_var_and_access_keys(variable, Enum.reverse(access_keys), state)

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

  # String case
  def store(
        %AuxiliaryNode{
          type: :storage_variable,
          value: %Variable{type: %Type{encoded_type: 1}} = variable,
          access_keys: []
        },
        %YulNode{} = value,
        %CompilerState{} = state,
        node
      ) do
    {_definition, slot, _keys_definition} = keccak_from_var_and_access_keys(variable, [], state)

    i_var_name = "storage_i_#{state.uniqueness_provider}$"
    i_end_var_name = "storage_i_#{state.uniqueness_provider}$end"
    size_var_name = "str_size$#{state.uniqueness_provider}$"
    slot_var_name = "slot_storage#{state.uniqueness_provider}$"

    usage =
      """
      let #{i_var_name} := #{value.yul_snippet_usage}

      #{Utils.generate_type_check(i_var_name, variable.type.encoded_type, "Wrong type for storage variable #{variable.name}", state.uniqueness_provider)}

      #{i_var_name} := add(#{i_var_name}, 1)
      let #{slot_var_name} := #{slot}

      let #{size_var_name} := mload(#{i_var_name})
      #{i_var_name} := add(#{i_var_name}, 32)
      let #{i_end_var_name} := add(#{i_var_name}, #{size_var_name})

      sstore(#{slot_var_name}, #{size_var_name})
      #{slot_var_name} := add(#{slot_var_name}, 1)

       for { } lt(#{i_var_name}, #{i_end_var_name})
       {
         #{i_var_name} := add(#{i_var_name}, 32)
         #{slot_var_name} := add(#{slot_var_name}, 1)
       }
       {
        sstore(#{slot_var_name}, mload(#{i_var_name}))
       }
      """

    {%YulNode{
       elixir_initial: node,
       meta: value.meta,
       yul_snippet_definition: value.yul_snippet_definition,
       yul_snippet_usage: usage,
       return_values_count: 0
     }, %CompilerState{state | uniqueness_provider: state.uniqueness_provider + 1}}
  end

  def store(
        %AuxiliaryNode{
          type: :storage_variable,
          value: variable,
          access_keys: access_keys
        },
        %YulNode{} = value,
        %CompilerState{} = state,
        node
      ) do
    {definition, slot, keys_definition} =
      keccak_from_var_and_access_keys(variable, Enum.reverse(access_keys), state)

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
     }, %CompilerState{state | uniqueness_provider: state.uniqueness_provider + 1}}
  end

  defp keccak_from_var_and_access_keys(variable, access_keys, state) do
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
                 #{Utils.generate_type_check(key.yul_snippet_usage, type.encoded_type, "Wrong type for storage variable access key", state.uniqueness_provider)}

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
