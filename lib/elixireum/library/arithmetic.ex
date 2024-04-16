defmodule Elixireum.Library.Arithmetic do
  alias Elixireum.{CompilerState, YulNode}
  alias Elixireum.Yul.Arithmetic

  def add(
        %YulNode{} = a,
        %YulNode{} = b,
        %CompilerState{used_standard_functions: used_standard_functions} = state,
        ast
      ) do
    meta =
      case ast do
        {_, meta, _} -> meta
        _ -> nil
      end

    {%YulNode{
       yul_snippet_usage: "add$(#{a.yul_snippet_usage}, #{b.yul_snippet_usage})",
       return_values_count: 1,
       elixir_initial: ast,
       meta: meta
     },
     %CompilerState{
       state
       | used_standard_functions: Map.put_new(used_standard_functions, :"add$", Arithmetic.add())
     }}
  end
end
