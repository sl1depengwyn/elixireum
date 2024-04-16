defmodule Blockchain.Storage do
  alias Blockchain.Type
  alias Elixireum.{CompilerState, Variable, YulNode}

  # TODO add mstore
  def get(%Variable{} = variable, %CompilerState{offset: offset} = state) do
    definition = """
    mstore8(add(#{offset}, offset$), #{variable.type.encoded_type})
    mstore(add(#{offset + 1}, offset$), sload(#{variable.storage_pointer}))
    """

    {%YulNode{
       yul_snippet_usage: "add(#{offset}, offset$)",
       return_values_count: 1,
       elixir_initial: nil,
       yul_snippet_definition: definition
     }, %CompilerState{state | offset: offset + variable.type.size + 1}}
  end

  def store(%Variable{} = variable, %YulNode{} = value, %CompilerState{} = state) do
    {%YulNode{
       elixir_initial: value.elixir_initial,
       meta: value.meta,
       yul_snippet_definition: value.yul_snippet_definition,
       yul_snippet_usage:
         "sstore(#{variable.storage_pointer}, take_#{variable.type.size}_bytes$(mload(add(#{value.yul_snippet_usage}, 1))))",
       return_values_count: 0
     },
     %CompilerState{
       state
       | used_standard_functions:
           Map.put_new(
             state.used_standard_functions,
             :"take_#{variable.type.size}_bytes$",
             apply(Elixireum.Yul.Utils, String.to_atom("take_#{variable.type.size}_bytes"), [])
           )
     }}
  end
end
