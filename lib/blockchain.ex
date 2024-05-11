defmodule Blockchain do
  alias Elixireum.{Compiler, CompilerState, YulNode}
  alias Elixireum.Library.Utils

  def tx_origin(compiler_state, node) do
    var_name = "_tx_origin$#{compiler_state.uniqueness_provider}"

    {%YulNode{
       yul_snippet_definition: """
       let #{var_name} := offset$
       mstore8(offset$, 68)
       offset$ := add(offset$, 1)
       mstore(offset$, shl(#{8 * 12}, origin()))
       offset$ := add(offset$, 20)
       """,
       elixir_initial: node,
       yul_snippet_usage: var_name,
       return_values_count: 1
     },
     %CompilerState{compiler_state | uniqueness_provider: compiler_state.uniqueness_provider + 1}}
  end

  def caller(compiler_state, node) do
    var_name = "_caller$#{compiler_state.uniqueness_provider}"

    {%YulNode{
       yul_snippet_definition: """
       let #{var_name} := offset$
       mstore8(offset$, 68)
       offset$ := add(offset$, 1)
       mstore(offset$, shl(#{8 * 12}, caller()))
       offset$ := add(offset$, 20)
       """,
       elixir_initial: node,
       yul_snippet_usage: var_name,
       return_values_count: 1
     },
     %CompilerState{compiler_state | uniqueness_provider: compiler_state.uniqueness_provider + 1}}
  end

  def revert(
        %YulNode{
          yul_snippet_definition: yul_snippet_definition,
          yul_snippet_usage: yul_snippet_usage
        },
        %CompilerState{uniqueness_provider: uniqueness_provider} = compiler_state,
        node
      ) do
    revert_mem_ptr = "revert_mem_ptr$#{uniqueness_provider}"
    revert_mem_size = "revert_mem_size$#{uniqueness_provider}"

    {%YulNode{
       yul_snippet_definition: """
       #{yul_snippet_definition}
       #{Utils.generate_type_check(yul_snippet_usage, 1, "Invalid argument for revert", compiler_state.uniqueness_provider)}
       let #{revert_mem_ptr} := add(1, #{yul_snippet_usage})
       let #{revert_mem_size} := mload(#{revert_mem_ptr})
       #{revert_mem_ptr} := add(#{revert_mem_ptr}, 32)
       """,
       yul_snippet_usage: "revert(#{revert_mem_ptr}, #{revert_mem_size})",
       elixir_initial: node,
       return_values_count: 0
     },
     %CompilerState{compiler_state | uniqueness_provider: compiler_state.uniqueness_provider + 1}}
  end
end
