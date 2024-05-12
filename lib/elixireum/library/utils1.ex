defmodule Elixireum.Library.Utils1 do
  alias Elixireum.Yul.Utils
  alias Elixireum.{CompilerState, YulNode}
alias Blockchain.Type
  def cast(
    %YulNode{} = var,
    %Elixireum.AuxiliaryNode{} = desired_type,
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
{:ok, type} = Type.from_module(desired_type.value, [])
var_name = "cast#{uniqueness_provider}$"

{%YulNode{
   yul_snippet_definition: """
   #{var.yul_snippet_definition}
   let #{var_name} := cast$(#{var.yul_snippet_usage}, #{type.encoded_type})
   offset$ := msize()
   """,
   yul_snippet_usage: var_name,
   return_values_count: 1,
   elixir_initial: ast,
   meta: meta
 },
 %CompilerState{
   state
   | used_standard_functions: Map.put_new(used_standard_functions, :"cast$", Utils.cast()),
     uniqueness_provider: uniqueness_provider + 1
 }}
end
end
