defmodule Elixireum.Compiler do
  @moduledoc """
  Elixireum Compiler
  """
  alias ElixirSense.Plugins.Util
  alias Blockchain.{Storage, Type}

  alias Elixireum.{
    ABIGenerator,
    AuxiliaryNode,
    CompilerState,
    Contract,
    Function,
    YulNode,
    Library,
    Variable,
    Typespec
  }

  alias Elixireum.Yul.StdFunction

  def compile(_args) do
    :erlang.put(:elixir_parser_columns, true)
    :erlang.put(:elixir_token_metadata, true)
    :erlang.put(:elixir_literal_encoder, false)

    file_name = "./examples/storage.exm"

    code =
      file_name
      |> File.read!()

    {_, _pid} = Kernel.LexicalTracker.start_link()

    %Contract{
      functions: functions_map,
      private_functions: private_functions_map,
      name: _,
      variables: _
    } =
      contract =
      with {_, _, _, _, tokens} <-
             code
             |> String.to_charlist()
             |> :elixir_tokenizer.tokenize(0, 0, []),
           {_, ast} <- :elixir_parser.parse(tokens),
           {_ast, acc} <-
             Macro.prewalk(
               ast,
               %{
                 functions: [],
                 specs: %{},
                 private_functions: [],
                 aliases: %{},
                 variables: %{},
                 storage_pointer: 0
               },
               &ast_to_contract_fields/2
             ) do
        dbg(ast)

        functions_map = functions_list_to_functions_map(acc.functions)
        private_functions_map = functions_list_to_functions_map(acc.private_functions)

        %Contract{
          functions: functions_map,
          private_functions: private_functions_map,
          name: nil,
          variables: acc.variables,
          aliases: acc.aliases
        }
        |> dbg()
      end

    yul =
      """
      object "contract" {
        code {
          datacopy(0, dataoffset("runtime"), datasize("runtime"))
          return(0, datasize("runtime"))
        }
        object "runtime" {
          code {
            #{generate_selector(Map.values(functions_map))}

            #{generate_functions(Map.values(functions_map) ++ Map.values(private_functions_map), contract)}

            #{Elixireum.Yul.Utils.copier_selector().yul}
            #{Elixireum.Yul.Utils.copy_dynamic_array_from_calldata().yul}
            #{Elixireum.Yul.Utils.copy_static_array_from_calldata().yul}
            #{Elixireum.Yul.Utils.copy_word_from_calldata().yul}
            #{Elixireum.Yul.Utils.get_type().yul}

          }
        }
      }
      """

    File.open!("./out.yul", [:write], fn file ->
      IO.write(file, yul)
    end)

    File.open!("./abi.json", [:write], fn file ->
      IO.write(file, ABIGenerator.generate(contract) |> Jason.encode_to_iodata!())
    end)
  end

  # TODO factor out elixir to yul code mapping

  defp generate_selector(functions) do
    """
    let method_id := shr(0xe0, calldataload(0x0))
    switch method_id
    #{for function <- functions do
      <<method_id::binary-size(8), _::binary>> = function |> function_to_keccak_bytes() |> Base.encode16(case: :lower)
      {extraction, usage} = typed_function_to_arguments(function)
      """
      case 0x#{method_id} {
        let calldata_offset$ := 4
        let memory_offset$ := 0
        #{extraction}
        let return_value$ := #{function.name}(#{usage})

        #{generate_return(function.typespec.return)}
      }
      """
    end}
    """
  end

  defp generate_return(nil) do
    """
    return(0, 0)
    """
  end

  defp generate_return(%Type{size: :dynamic} = type) do
    """
    let processed_return_value$ := msize()
    let processed_return_value_init$ := processed_return_value$
    let where_to_store_head$ := processed_return_value$
    let where_to_store_head_init$ := where_to_store_head$
    processed_return_value$ := add(processed_return_value$, 32)
    #{do_generate_return(type, "i$", "size$", "where_to_store_head$", "where_to_store_head_init$")}
    return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
    """
  end

  defp generate_return(type) do
    """
    let processed_return_value$ := msize()
    let processed_return_value_init$ := processed_return_value$
    let where_to_store_head$ := processed_return_value$
    let where_to_store_head_init$ := where_to_store_head$
    #{do_generate_return(type, "i$", "size$", "where_to_store_head$", "where_to_store_head_init$")}
    processed_return_value$ := add(processed_return_value$, #{type.size})
    return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
    """
  end

  defp do_generate_return(
         %Type{
           encoded_type: 103 = encoded_type,
           items_count: size,
           components: [components]
         },
         i_var_name,
         size_var_name,
         where_to_store_head_var_name,
         where_to_store_head_init_var_name
       )
       when is_integer(size) do
    """
    switch byte(0, mload(return_value$))
      case #{encoded_type} {}
      default {
        // Return type mismatch abi
        revert(0, 0)
      }

    return_value$ := add(return_value$, 1)
    let #{size_var_name} := mload(return_value$)

    switch #{size_var_name}
      case #{size} {}
      default {
        // Array size mismatch
        revert(0, 0)
      }

    return_value$ := add(return_value$, 32)

    for { let #{i_var_name} := 0 } lt(#{i_var_name}, #{size_var_name}) { #{i_var_name} := add(#{i_var_name}, 1) } {
    //for { let #{i_var_name} := 0 } lt(#{i_var_name}, 2) { #{i_var_name} := add(#{i_var_name}, 1) } {

      #{do_generate_return(components, i_var_name <> "_", size_var_name <> "_", where_to_store_head_var_name, where_to_store_head_init_var_name)}
    }
    """
  end

  defp do_generate_return(
         %Type{
           encoded_type: 104 = encoded_type,
           size: :dynamic,
           components: [components]
         },
         i_var_name,
         size_var_name,
         where_to_store_head_var_name,
         where_to_store_head_init_var_name
       ) do
    where_to_store_children_heads_var_name = "#{where_to_store_head_var_name}_$"
    where_to_store_children_heads_init_var_name = "#{where_to_store_head_init_var_name}_$"

    """
    switch byte(0, mload(return_value$))
      case #{encoded_type} {}
      default {
        // Return type mismatch abi
        revert(0, 0)
      }
    return_value$ := add(return_value$, 1)

    let #{size_var_name} := mload(return_value$)
    return_value$ := add(return_value$, 32)

    mstore(#{where_to_store_head_var_name}, sub(processed_return_value$, #{where_to_store_head_init_var_name}))
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)

    mstore(processed_return_value$, #{size_var_name})
    processed_return_value$ := add(processed_return_value$, 32)
    let #{where_to_store_children_heads_var_name} := processed_return_value$
    let #{where_to_store_children_heads_init_var_name} := #{where_to_store_children_heads_var_name}

    processed_return_value$ := add(processed_return_value$, mul(#{size_var_name}, #{type_to_head_size(components)}))

    for { let #{i_var_name} := 0 } lt(#{i_var_name}, #{size_var_name}) { #{i_var_name} := add(#{i_var_name}, 1) } {
    // for { let #{i_var_name} := 0 } lt(#{i_var_name}, 2) { #{i_var_name} := add(#{i_var_name}, 1) } {
      #{do_generate_return(components, i_var_name <> "_", size_var_name <> "_", where_to_store_children_heads_var_name, where_to_store_children_heads_init_var_name)}
    }
    """
  end

  # add handling bool type
  defp do_generate_return(
         type,
         _i_var_name,
         _size_var_name,
         where_to_store_head_var_name,
         _where_to_store_head_init_var_name
       ) do
    """
    switch byte(0, mload(return_value$))
      case #{type.encoded_type} {}
      default {
        // Return type mismatch abi
        revert(0, 0)
      }

    return_value$ := add(return_value$, 1)
    mstore(#{where_to_store_head_var_name}, mload(return_value$))
    return_value$ := add(return_value$, 32)
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)
    """
  end

  defp type_to_head_size(%Type{size: :dynamic}) do
    32
  end

  defp type_to_head_size(%Type{size: size}) do
    size
  end

  defp function_to_keccak_bytes(function) do
    "#{to_string(function.name)}(#{Enum.map_join(function.typespec.args, ",", & &1.abi_name)})"
    |> to_string()
    |> ExKeccak.hash_256()
  end

  defp typed_function_to_arguments(function) do
    {functions_extraction, _} =
      function.args
      |> Enum.zip(function.typespec.args)
      |> Enum.reduce(
        {"""
         let calldata_offset := 4
         let memory_offset := msize()
         """, 0},
        &do_typed_function_to_arguments/2
      )

    {functions_extraction, function.args |> Enum.join(",")}
  end

  defp do_typed_function_to_arguments(
         {arg_name, %Type{components: [_components]} = type},
         {yul, calldata_offset}
       ) do
    {types, sizes} = type_to_types_and_sizes(type)
    types = Enum.reverse(types)
    sizes = Enum.reverse(sizes)

    {
      yul <>
        """
        let #{arg_name}_types := msize()
        mstore8(#{arg_name}_types, 103)
        mstore(add(#{arg_name}_types, 1), #{Enum.count(types)})
        #{for {type, index} <- Enum.with_index(types) do
          """
          mstore8(add(#{arg_name}_types, #{index * 33 + 33}), 67)
          mstore(add(#{arg_name}_types, #{index * 33 + 33 + 1}), #{type})
          """
        end}
        let #{arg_name}_sizes := add(#{arg_name}_types, #{Enum.count(types) * 33 + 33})
        mstore8(#{arg_name}_sizes, 103)
        mstore(add(#{arg_name}_sizes, 1), #{Enum.count(sizes)})
        #{for {size, index} <- Enum.with_index(sizes) do
          """
          mstore8(add(#{arg_name}_sizes, #{index * 33 + 33}), 67)
          mstore(add(#{arg_name}_sizes, #{index * 33 + 33 + 1}), #{size})
          """
        end}

        memory_offset := add(memory_offset, #{Enum.count(types) * 33 + 33 + Enum.count(sizes) * 33 + 33})
        let #{arg_name} := memory_offset
        memory_offset, calldata_offset := select_and_call$(#{arg_name}_types, #{arg_name}_sizes, memory_offset, calldata_offset, calldata_offset, #{Enum.count(types)})
        """,
      calldata_offset + 32
    }
  end

  # defp do_typed_function_to_arguments(
  #        {arg_name, %Type{encoded_type: 103, size: :dynamic, components: [components]} = type},
  #        {yul, calldata_offset}
  #      ) do
  #   {
  #     yul <>
  #       """
  #       let #{arg_name}_offset := msize()
  #       let #{arg_name} := #{arg_name}_offset
  #       mstore8(#{arg_name}_offset, #{type.encoded_type})

  #       let #{arg_name}_calldata_offset := add(4, calldataload(#{4 + calldata_offset}))
  #       let #{arg_name}_size := calldataload(#{arg_name}_calldata_offset)
  #       mstore(add(1, #{arg_name}_offset), #{arg_name}_size)

  #       for { let i := 1 } lt(i, add(1, #{arg_name}_size)) { i := add(i, 1) } {
  #         mstore8(add(#{arg_name}_offset, mul(i, #{1 + components.size})), #{components.encoded_type})
  #         mstore(add(add(1, #{arg_name}_offset), mul(i, #{1 + components.size})), calldataload(add(#{arg_name}_calldata_offset, mul(i, 32))))
  #       }
  #       """,
  #     calldata_offset + 32
  #   }
  # end

  # defp do_typed_function_to_arguments(
  #        {arg_name, %Type{encoded_type: 103, size: byte_size, components: [components]} = type},
  #        {yul, calldata_offset}
  #      ) do
  #   arr_size = div(byte_size, components.size)

  #   {
  #     yul <>
  #       """
  #       let #{arg_name}_offset := msize()
  #       let #{arg_name} := #{arg_name}_offset
  #       mstore8(#{arg_name}_offset, #{type.encoded_type})
  #       mstore(add(1, #{arg_name}_offset), #{arr_size})
  #       """ <>
  #       """
  #       for { let i := 0 } lt(i, #{arr_size}) { i := add(i, 1) } {
  #         mstore8(add(add(33, #{arg_name}_offset), mul(i, #{1 + components.size})), #{components.encoded_type})
  #         mstore(add(add(34, #{arg_name}_offset), mul(i, #{1 + components.size})), calldataload(add(4, add(#{calldata_offset}, mul(i, 32)))))
  #       }
  #       """,
  #     calldata_offset + arr_size * 32
  #   }
  # end

  defp do_typed_function_to_arguments(
         {arg_name, %Type{} = type},
         {yul, calldata_offset}
       ) do
    {
      yul <>
        """
        let #{arg_name} := memory_offset
        memory_offset, calldata_offset := copy_word_from_calldata$(memory_offset, calldata_offset, #{type.encoded_type})
        """,
      calldata_offset + 32
    }
  end

  defp type_to_types_and_sizes(%Type{encoded_type: type, size: :dynamic, components: [components]}) do
    {types, sizes} = type_to_types_and_sizes(components)

    {[type | types], sizes}
  end

  defp type_to_types_and_sizes(%Type{
         encoded_type: type,
         size: _,
         components: [components],
         items_count: size
       }) do
    {types, sizes} = type_to_types_and_sizes(components)

    {[type | types], [size | sizes]}
  end

  defp type_to_types_and_sizes(%Type{encoded_type: type, size: _, items_count: size}) do
    {[type], []}
  end

  defp functions_list_to_functions_map(functions) do
    Enum.reduce(functions, %{}, fn function, acc ->
      Map.put(acc, function.name, function)
    end)
  end

  def ast_to_contract_fields({:@, _meta, [{:spec, _, spec_body}]} = node, acc) do
    {function_name, typespec} = process_spec_body(spec_body, acc)
    {node, Map.put(acc, :specs, Map.put(acc[:specs], function_name, typespec))}
  end

  def ast_to_contract_fields({:@, _meta, [{var_name, _, [var_properties]}]} = node, acc) do
    cond do
      Map.has_key?(acc.aliases, var_name) ->
        raise "#{var_name} is already aliased"

      not Keyword.has_key?(var_properties, :type) ->
        raise "#{var_name} has no type"

      true ->
        type = process_arg_type(Keyword.fetch!(var_properties, :type), acc)

        {node,
         %{
           acc
           | variables:
               Map.put(acc.variables, var_name, %Variable{
                 name: var_name,
                 type: type,
                 storage_pointer: acc.storage_pointer
               }),
             storage_pointer: acc.storage_pointer + type.size
         }}
    end
  end

  def ast_to_contract_fields({:def, _meta, children} = node, acc) do
    [{function_name, _, args} | body] = children
    # TODO add also check suitability of typespec by it's args

    function = %Function{
      name: function_name,
      typespec: fetch_spec(acc[:specs], function_name),
      body: body,
      args: extract_args(args),
      private?: false
    }

    {node, Map.put(acc, :functions, [function | acc[:functions]])}
  end

  def ast_to_contract_fields({:defp, _meta, children} = node, acc) do
    [{function_name, _, args} | body] = children
    # TODO add also check suitability of typespec by it's args

    function = %Function{
      name: function_name,
      body: body,
      args: extract_args(args),
      private?: true
    }

    {node, Map.put(acc, :private_functions, [function | acc[:private_functions]])}
  end

  def ast_to_contract_fields(
        {:alias, _meta, [{:__aliases__, _meta_inner, modules_list}]} = other,
        %{aliases: aliases} = acc
      ) do
    {other, %{acc | aliases: Map.put(aliases, List.last(modules_list), modules_list)}}
  end

  def ast_to_contract_fields(
        {:alias, _, [{:__aliases__, _, modules_list}, [as: {_, _, [aliased]}]]} =
          other,
        %{aliases: aliases} = acc
      ) do
    {other, %{acc | aliases: Map.put(aliases, aliased, modules_list)}}
  end

  def ast_to_contract_fields(
        {:alias, _meta,
         [
           {{:., _,
             [
               {:__aliases__, _, modules_list},
               :{}
             ]}, _, aliases_list}
         ]} = other,
        %{aliases: aliases} = acc
      ) do
    aliases =
      Enum.reduce(aliases_list, aliases, fn {:__aliases__, _, aliases}, aliases_acc ->
        {key, other_modules} = List.pop_at(aliases, -1)
        Map.put(aliases_acc, key, modules_list ++ other_modules ++ [key])
      end)

    {other, %{acc | aliases: aliases}}
  end

  def ast_to_contract_fields(other, acc) do
    {other, acc}
  end

  defp extract_args(args) do
    Enum.map(args, &elem(&1, 0))
  end

  defp process_spec_body(
         [{:"::", _meta, [{function_name, _meta_args, args} = _left, right]}],
         acc
       ) do
    {function_name,
     %Typespec{args: process_args_types(args, acc), return: right && process_arg_type(right, acc)}}
  end

  defp process_args_types(args, acc) do
    args
    |> Enum.map(&process_arg_type(&1, acc))
  end

  defp process_arg_type({{:., _, [{:__aliases__, _, aliases_list}, :t]}, _, args}, acc) do
    aliases = prepare_aliases(acc.aliases, aliases_list)

    case Type.from_module(aliases, Enum.map(args, &process_arg_type_args(&1, acc))) do
      {:ok, module} -> module
      {:error, error_text} -> raise "Wrong type: #{error_text}"
    end
  end

  defp process_arg_type_args(
         {{:., _, [{:__aliases__, _, _aliases_list}, :t]}, _, _args} = arg_type_arg,
         acc
       ) do
    process_arg_type(arg_type_arg, acc)
  end

  defp process_arg_type_args(arg_type_arg, _acc), do: arg_type_arg

  defp fetch_spec(specs, function_name) do
    if specs[function_name] do
      specs[function_name]
    else
      raise "You must define spec for public functions (`def`)! \n Couldn't find spec for #{function_name}"
    end
  end

  defp generate_functions(functions, contract) do
    {user_defined_functions, compiler_state} =
      Enum.reduce(functions, {"", %CompilerState{aliases: contract.aliases}}, fn function,
                                                                                 {yul_acc,
                                                                                  compiler_state_acc} ->
        {yul, updated_compiler_state} = generate_function(function, contract, compiler_state_acc)
        {yul_acc <> yul, updated_compiler_state}
      end)

    {_, std_functions} = generate_std_functions(compiler_state.used_standard_functions)

    user_defined_functions <> Enum.join(std_functions, "\n")
  end

  defp generate_function(function, contract, compiler_state) do
    {last, other} = prepare_children(function.body)

    {ast, acc} =
      Macro.postwalk(
        other,
        %CompilerState{
          aliases: contract.aliases,
          storage_variables: contract.variables,
          used_standard_functions: compiler_state.used_standard_functions
        },
        &expand_expression/2
      )

    {ast_last, acc} =
      Macro.postwalk(last, acc, &expand_expression/2)

    dbg(function)

    user_defined_functions =
      cond do
        function.typespec &&
            ((function.typespec.return && ast_last.return_values_count != 1) ||
               (!function.typespec.return && ast_last.return_values_count != 0)) ->
          raise "Typespec mismatches for #{function.name}!"

        (function.typespec && function.typespec.return && ast_last.return_values_count == 1) ||
          (!function.typespec && ast_last.return_values_count == 1) || true ->
          """
          function #{function.name}(#{Enum.join(function.args, ", ")}) -> return_value$ {
            let offset$ := msize()
            #{Enum.map_join(ast, "\n", fn yul_node -> if yul_node.return_values_count > 0 do
              """
              #{yul_node.yul_snippet_definition}
              let #{1..yul_node.return_values_count |> Enum.map_join(", ", fn _ -> "_" end)} := #{yul_node.yul_snippet_usage}
              """
            else
              """
              #{yul_node.yul_snippet_definition}
              #{yul_node.yul_snippet_usage}
              """
            end end)}
            #{ast_last.yul_snippet_definition}
            #{if ast_last.return_values_count > 0 do
            "return_value$ := #{ast_last.yul_snippet_usage}"
          else
            "#{ast_last.yul_snippet_usage}"
          end}
          }
          """

          # todo left comment
          # (function.typespec && (!function.typespec.return && ast_last.return_values_count == 0)) ||
          #     (!function.typespec && ast_last.return_values_count == 0) ->
          #   """
          #   function #{function.name}(#{Enum.join(function.args, ", ")}) -> return_value {

          #     #{Enum.map_join(ast, "\n", & "#{&1.yul_snippet_usage}")}

          #     #{ast_last.yul_snippet_definition}
          #     #{ast_last.yul_snippet_usage}
          #   }
          #   """
      end

    {user_defined_functions, acc}
  end

  ## {Enum.map_join(ast, "\n", & &1.yul_snippet)}
  #   # todo left comment
  #   (function.typespec && (!function.typespec.return && ast_last.return_values_count == 0)) ||
  #   (!function.typespec && ast_last.return_values_count == 0) ->
  # """
  # function #{function.name}(#{Enum.join(function.args, ", ")})  {
  #   #{Enum.map_join(ast, "\n", & &1.yul_snippet)}

  #   #{ast_last.yul_snippet}
  # }
  # """

  defp prepare_children([[do: {:__block__, meta, children}]]) do
    {last, other} = List.pop_at(children, -1)
    {last, {:__block__, meta, other}}
  end

  defp prepare_children([[do: child]]) do
    {child, {:__block__, nil, []}}
  end

  defp generate_std_functions(used_std_functions, definitions \\ []) do
    Enum.reduce(used_std_functions, {%{}, definitions}, fn function,
                                                           {used_functions_acc, definitions_acc} ->
      %StdFunction{yul: yul, deps: deps} = function.()

      {_, not_defined_deps} = Map.split(deps, Map.keys(used_functions_acc))

      generate_std_functions(not_defined_deps, [yul | definitions_acc])
    end)
  end

  @disallowed_actions_inside_function ~w(defmodule def defp)a

  defp expand_expression({action, _, _}, _acc)
       when action in @disallowed_actions_inside_function do
    raise "`#{action}` inside functions is not allowed!"
  end

  defp expand_expression(
         {:=, meta,
          [
            %Elixireum.YulNode{
              elixir_initial: {var_name, _, _}
            },
            %YulNode{
              yul_snippet_definition: yul_snippet_definition,
              yul_snippet_usage: yul_snippet_right,
              elixir_initial: _something
            }
          ]} = node,
         %CompilerState{declared_variables: declared_variables, variables: _variables} = state
       ) do
    {yul_snippet_left, declared_variables} =
      if MapSet.member?(declared_variables, var_name) do
        {"#{var_name}", declared_variables}
      else
        {"let #{var_name}", MapSet.put(declared_variables, var_name)}
      end

    yul_snippet_final = "#{yul_snippet_left} := #{yul_snippet_right}"

    {%YulNode{
       yul_snippet_definition: yul_snippet_definition,
       yul_snippet_usage: yul_snippet_final,
       meta: meta,
       return_values_count: 0,
       elixir_initial: node
     }, %CompilerState{state | declared_variables: declared_variables}}
  end

  defp expand_expression(
         {%AuxiliaryNode{type: :function_call, value: {[:Blockchain, :Storage], :store}}, meta,
          [
            %Elixireum.AuxiliaryNode{
              type: :storage_variable,
              value: variable
            },
            yul_node
          ]} = node,
         acc
       ) do
    {%{yul_snippet_usage: yul_snippet, return_values_count: return_values_count}, acc} =
      Storage.store(variable, yul_node, acc)

    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: yul_snippet,
       meta: meta,
       return_values_count: return_values_count,
       elixir_initial: node
     }, acc}
  end

  defp expand_expression(
         {%AuxiliaryNode{type: :function_call, value: {[:Blockchain, :Storage], :get}}, meta,
          [
            %Elixireum.AuxiliaryNode{
              type: :storage_variable,
              value: variable
            }
          ]} = node,
         acc
       ) do
    {%{
       yul_snippet_usage: yul_snippet,
       return_values_count: return_values_count,
       yul_snippet_definition: yul_snippet_definition
     },
     acc} =
      Storage.get(variable, acc)

    {%YulNode{
       yul_snippet_definition: yul_snippet_definition,
       yul_snippet_usage: yul_snippet,
       meta: meta,
       return_values_count: return_values_count,
       elixir_initial: node
     }, acc}
  end

  defp expand_expression(
         {%AuxiliaryNode{type: :function_call, value: {_module_list, _function_name}}, _meta,
          _args_as_yul_nodes} = all,
         _acc
       ) do
    dbg(all)
    raise "Something went wrong"
  end

  defp expand_expression(
         {:., _meta,
          [
            %AuxiliaryNode{type: :__aliases__, value: aliased_list},
            %YulNode{elixir_initial: function_name}
          ]},
         acc
       ) do
    {%AuxiliaryNode{
       type: :function_call,
       value: {aliased_list, function_name}
     }, acc}
  end

  defp expand_expression({:__aliases__, _meta, yul_nodes}, %CompilerState{aliases: aliases} = acc) do
    prepared = prepare_aliases(aliases, Enum.map(yul_nodes, & &1.elixir_initial))
    {%AuxiliaryNode{type: :__aliases__, value: prepared}, acc}
  end

  defp expand_expression({:@, _meta, [%YulNode{elixir_initial: {var_name, _, nil}}]}, acc) do
    case Map.fetch(acc.storage_variables, var_name) do
      {:ok, var} -> {%AuxiliaryNode{type: :storage_variable, value: var}, acc}
      _ -> raise "@#{var_name} is not declared"
    end
  end

  defp expand_expression({:__block__, _meta, children}, acc) do
    {children, acc}
  end

  defp expand_expression({function_name, meta, args} = node, acc)
       when is_atom(function_name) and is_list(args) do
    # dbg(other)
    # # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # # {other, acc}

    definition =
      "#{Enum.map_join(args, "\n", fn yul_node -> yul_node.yul_snippet_definition end)}"

    case Library.Utils.method_atom_to_yul(function_name) do
      :error ->
        {%YulNode{
           yul_snippet_definition: definition,
           yul_snippet_usage:
             "#{function_name}(#{Enum.map_join(args, ", ", fn yul_node -> yul_node.yul_snippet_usage end)})",
           meta: meta,
           elixir_initial: node,
           return_values_count: 1
         }, acc}

      library_fun when is_function(library_fun, length(args) + 2) ->
        {yul_node, state} = apply(library_fun, args ++ [acc, node])
        {%YulNode{yul_node | yul_snippet_definition: definition}, state}

      _ ->
        raise "#{function_name}/#{length(args)} is undefined"
    end
  end

  # variable
  defp expand_expression({var, meta, nil} = other, %CompilerState{variables: _variables} = acc)
       when is_atom(var) do
    dbg(other)
    # dbg(other)
    # # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # # {other, acc}
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: to_string(var),
       meta: meta,
       elixir_initial: other,
       return_values_count: 1
     }, acc}
  end

  defp expand_expression({_node, _meta, _} = other, _acc) do
    raise "Not implemented: #{inspect(other)}"
    # dbg(other)
    # # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # {%YulNode{yul_snippet: "IGNORED111", meta: meta}, acc}
    # # {other, acc}
  end

  defp expand_expression(list, acc) when is_list(list) do
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: "LIST_TO_IMPLEMENT",
       meta: nil,
       elixir_initial: list,
       return_values_count: 1
     }, acc}
  end

  defp expand_expression(atom, state) when is_atom(atom) do
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: to_string(atom),
       meta: nil,
       elixir_initial: atom,
       return_values_count: 1
     }, state}
  end

  defp expand_expression(other, %CompilerState{offset: offset} = state) do
    definition =
      """
      mstore8(add(#{offset}, offset$), #{Type.elixir_to_encoded_type(other)})
      mstore(add(#{offset + 1}, offset$), #{to_string(other)})
      """

    usage = "add(#{offset}, offset$)"

    {%YulNode{
       yul_snippet_definition: definition,
       yul_snippet_usage: usage,
       meta: nil,
       elixir_initial: other,
       return_values_count: 1
     }, %CompilerState{state | offset: offset + Type.elixir_to_size(other) + 1}}
  end

  defp prepare_aliases(aliases, [head | tail]) do
    (aliases[head] || [head]) ++ tail
  end
end
