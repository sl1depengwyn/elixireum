defmodule Elixireum.Library.Arithmetic do
  alias Elixireum.{CompilerState, YulNode}
  alias Elixireum.Yul.Arithmetic

  def add(
        %YulNode{} = a,
        %YulNode{} = b,
        %CompilerState{
          used_standard_functions: used_standard_functions,
          function_calls_counter: function_calls_counter
        } = state,
        ast
      ) do
    meta =
      case ast do
        {_, meta, _} -> meta
        _ -> nil
      end

    var_name = "add$#{function_calls_counter}"

    {%YulNode{
       yul_snippet_definition: """
       let #{var_name} := add$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"add$", Arithmetic.add()),
         function_calls_counter: function_calls_counter + 1
     }}
  end
end
