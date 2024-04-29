defmodule Elixireum.Library.Arithmetic do
  alias Elixireum.{CompilerState, YulNode}
  alias Elixireum.Yul.Arithmetic

  def add(
        %YulNode{} = a,
        %YulNode{} = b,
        %CompilerState{
          used_standard_functions: used_standard_functions,
          uniqueness_provider: uniqueness_provider
        } = state,
        ast
      ) do
    meta =
      case ast do
        {_, meta, _} -> meta
        _ -> nil
      end

    var_name = "add$#{uniqueness_provider}"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       #{b.yul_snippet_definition}
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
         uniqueness_provider: uniqueness_provider + 1
     }}
  end

  def sub(
        %YulNode{} = a,
        %YulNode{} = b,
        %CompilerState{
          used_standard_functions: used_standard_functions,
          uniqueness_provider: uniqueness_provider
        } = state,
        ast
      ) do
    meta =
      case ast do
        {_, meta, _} -> meta
        _ -> nil
      end

    var_name = "add$#{uniqueness_provider}"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       #{b.yul_snippet_definition}
       let #{var_name} := sub$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"sub$", Arithmetic.sub()),
         uniqueness_provider: uniqueness_provider + 1
     }}
  end
end
