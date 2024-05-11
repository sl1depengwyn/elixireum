defmodule Elixireum.Library.Comparison do
  alias Elixireum.{CompilerState, YulNode}
  alias Elixireum.Yul.Comparison

  def equal?(
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

    var_name = "equal#{uniqueness_provider}$"

    {%YulNode{
       yul_snippet_definition: """
       #{a.yul_snippet_definition}
       #{b.yul_snippet_definition}
       let #{var_name} := equal$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
       offset$ := msize()
       """,
       yul_snippet_usage: var_name,
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions:
           Map.put_new(used_standard_functions, :"equal$", Comparison.equal?())
     }}
  end

  def greater?(
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

var_name = "greater#{uniqueness_provider}$"

{%YulNode{
   yul_snippet_definition: """
   #{a.yul_snippet_definition}
   #{b.yul_snippet_definition}
   let #{var_name} := greater$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
   offset$ := msize()
   """,
   yul_snippet_usage: var_name,
   return_values_count: 1,
   elixir_initial: ast,
   meta: meta
 },
 %CompilerState{
   state
   | used_standard_functions:
       Map.put_new(used_standard_functions, :"greater$", Comparison.greater?())
 }}
end
def less?(
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

var_name = "less#{uniqueness_provider}$"

{%YulNode{
 yul_snippet_definition: """
 #{a.yul_snippet_definition}
 #{b.yul_snippet_definition}
 let #{var_name} := less$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})
 offset$ := msize()
 """,
 yul_snippet_usage: var_name,
 return_values_count: 1,
 elixir_initial: ast,
 meta: meta
},
%CompilerState{
 state
 | used_standard_functions:
     Map.put_new(used_standard_functions, :"less$", Comparison.less?())
}}
end
end
