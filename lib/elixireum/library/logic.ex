defmodule Elixireum.Library.Logic do
  alias Elixireum.{CompilerState, YulNode}
  alias Elixireum.Yul.Logic

  def or_op(
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

    var_name = "or#{uniqueness_provider}$"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       #{b.yul_snippet_definition}
       let #{var_name} := or$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"or$", Logic.or_def()),
         uniqueness_provider: uniqueness_provider + 1
     }}
  end

  def and_op(
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

    var_name = "or#{uniqueness_provider}$"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       #{b.yul_snippet_definition}
       let #{var_name} := and$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"and$", Logic.and_def()),
         uniqueness_provider: uniqueness_provider + 1
     }}
  end

  def not_op(
        %YulNode{} = a,
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

    var_name = "not#{uniqueness_provider}$"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       let #{var_name} := not$(#{a.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"not$", Logic.not_def()),
         uniqueness_provider: uniqueness_provider + 1
     }}
  end
end
