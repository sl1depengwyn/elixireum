defmodule Blockchain do
  alias Elixireum.YulNode
  alias Elixireum.CompilerState

  def tx_origin(node, compiler_state) do
    var_name = "tx_origin$#{compiler_state.uniqueness_provider}"

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
end
