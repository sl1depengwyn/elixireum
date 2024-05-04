defmodule Elixireum.Compiler do
  @moduledoc """
  Elixireum Compiler
  """

  alias Blockchain.{Address, Event, Type}

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

  alias Elixireum.Compiler.{Calldata, Return}
  alias Elixireum.Yul.StdFunction

  def compile(args) do
    :erlang.put(:elixir_parser_columns, true)
    :erlang.put(:elixir_token_metadata, true)
    :erlang.put(:elixir_literal_encoder, false)

    # "./examples/storage.exm"
    file_name = args[:source]

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
        # elixir_env:new())#{line := 1, file := File, tracers := elixir_config:get(tracers)
        # Code.string_to_quoted
        # :elixir_expand.expand(ast, __ENV__, __ENV__)

      with {_, _, _, _, tokens} <-
             code
             |> String.to_charlist()
             |> :elixir_tokenizer.tokenize(0, 0, []),
          #  {_, ast} <- :elixir_parser.parse(tokens) |> dbg(limit: :infinity, printable_limit: :infinity),
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
                 events: %{},
                 storage_vars_counter: 0
               },
               &ast_to_contract_fields/2
             ) do
        # dbg(acc)
        functions_map = functions_list_to_functions_map(acc.functions)
        private_functions_map = functions_list_to_functions_map(acc.private_functions)

        %Contract{
          functions: functions_map,
          private_functions: private_functions_map,
          name: nil,
          variables: acc.variables,
          aliases: acc.aliases,
          events: acc.events
        }
      end

    yul =
      """
      object "contract" {
        code {
          #{generate_deployment(functions_map[:constructor], contract)}
        }
        object "runtime" {
          code {
            #{generate_selector(functions_map |> Map.drop([:constructor]) |> Map.values())}

            #{generate_functions(Map.values(functions_map) ++ Map.values(private_functions_map), contract)}
          }
        }
      }
      """

    %{yul: yul, abi: ABIGenerator.generate(contract)}
  end

  defp generate_deployment(nil, _contract) do
    """
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
    """
  end

  defp generate_deployment(%Function{typespec: %Typespec{return: nil}} = constructor, contract) do
    {extraction, usage} =
      typed_function_to_arguments(
        constructor,
        "0",
        "sub(codesize(), datasize(\"contract\"))",
        :memory
      )

    """
    {
      let programSize := datasize("contract")
      let argSize := sub(codesize(), programSize)

      codecopy(0, programSize, argSize)

      #{extraction}
      let _$ := #{constructor.name}(#{usage})
      let code_offset$ := msize()
      datacopy(code_offset$, dataoffset("runtime"), datasize("runtime"))
      return(code_offset$, datasize("runtime"))
    }
    #{generate_functions([constructor], contract)}
    """
  end

  defp generate_deployment(_, _contract) do
    raise "Constructor should not return anything"
  end

  # TODO factor out elixir to yul code mapping
  # 224 / 8 = 28 = 0xe0
  defp generate_selector(functions) do
    """
    let method_id := shr(224, calldataload(0x0))
    switch method_id
    #{for function <- functions do
      <<method_id::binary-size(8), _::binary>> = function |> function_to_keccak_bytes() |> Base.encode16(case: :lower)
      {extraction, usage} = typed_function_to_arguments(function, 4, 0, :calldata)
      """
      case 0x#{method_id} {
        #{extraction}
        let return_value$ := #{function.name}(#{usage})

        #{generate_return(function.typespec.return)}
      }
      """
    end}
    default {revert(0, 0)}
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
    #{Return.encode(type, "i$", "size$", "where_to_store_head$", "where_to_store_head_init$")}
    return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
    """
  end

  defp generate_return(type) do
    size = (type.items_count || 1) * 32

    """
    let processed_return_value$ := msize()
    let processed_return_value_init$ := processed_return_value$
    let where_to_store_head$ := processed_return_value$
    let where_to_store_head_init$ := where_to_store_head$
    #{Return.encode(type, "i$", "size$", "where_to_store_head$", "where_to_store_head_init$")}
    processed_return_value$ := add(processed_return_value$, #{size})
    return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
    """
  end

  defp function_to_keccak_bytes(function) do
    "#{function.name}(#{Enum.map_join(function.typespec.args, ",", &do_function_to_keccak_bytes/1)})"
    |> ExKeccak.hash_256()
  end

  def do_function_to_keccak_bytes(%Type{encoded_type: 3, components: components}) do
    "#{Enum.map_join(components, ",", &do_function_to_keccak_bytes/1)})"
  end

  def do_function_to_keccak_bytes(arg) do
    arg.abi_name
  end

  defp typed_function_to_arguments(function, calldata_offset, memory_offset, data_origin) do
    {load_fn, copy_fn} =
      case data_origin do
        :memory ->
          {"mload", "mcopy"}

        :calldata ->
          {"calldataload", "calldatacopy"}
      end

    functions_extraction =
      function.args
      |> Enum.zip(function.typespec.args)
      |> Enum.reduce(
        """
        let calldata_offset$ := #{calldata_offset}
        let init_calldata_offset$ := calldata_offset$
        let memory_offset$ := #{memory_offset}
        """,
        &do_typed_function_to_arguments(&1, &2, load_fn, copy_fn)
      )

    {functions_extraction, function.args |> Enum.map_join(",", &"_#{&1}")}
  end

  defp do_typed_function_to_arguments(
         {arg_name, %Type{} = type},
         yul,
         data_load_fn,
         data_copy_fn
       ) do
    yul <>
      """
        let _#{arg_name} := memory_offset$
        #{Calldata.decode(to_string(arg_name), type, data_load_fn, data_copy_fn, "calldata_offset$", "init_calldata_offset$")}
      """
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

  def ast_to_contract_fields(
        {:@, _meta, [{internal_event_name, _meta_, [[_, _, _] = args]}]} = node,
        acc
      ) do
    data_arguments = Keyword.get(args, :data_arguments)
    indexed_arguments = Keyword.get(args, :indexed_arguments)

    event_name = Keyword.get(args, :name)

    prepared_data_arguments =
      for {var_name, var_type} <- data_arguments do
        {var_name, process_arg_type(var_type, acc)}
      end

    prepared_indexed_arguments =
      for {var_name, var_type} <- indexed_arguments do
        {var_name, process_arg_type(var_type, acc)}
      end

    {node,
     Map.put(
       acc,
       :events,
       Map.put(
         acc[:events],
         internal_event_name,
         Event.new(%{
           name: event_name,
           data_arguments: prepared_data_arguments,
           indexed_arguments: prepared_indexed_arguments
         })
       )
     )}
  end

  def ast_to_contract_fields({:@, _meta, [{var_name, _, [var_properties]}]} = node, acc) do
    cond do
      Map.has_key?(acc.aliases, var_name) ->
        raise "#{var_name} is already aliased"

      not Keyword.has_key?(var_properties, :type) ->
        raise "#{var_name} has no type"

      true ->
        {type, access_keys_types} =
          process_var_type(Keyword.fetch!(var_properties, :type), acc)

        {node,
         %{
           acc
           | variables:
               Map.put(acc.variables, var_name, %Variable{
                 name: var_name,
                 type: type,
                 access_keys_types: access_keys_types,
                 encoded_name: acc.storage_vars_counter
               }),
             storage_vars_counter: acc.storage_vars_counter + 1
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

  defp process_var_type(
         {:%{}, _,
          [
            {
              key_type,
              value_type
            }
          ]},
         acc
       ) do
    key_type = process_arg_type(key_type, acc)

    {type, access_keys} = process_var_type(value_type, acc)
    {type, [key_type | access_keys]}
  end

  defp process_var_type(type, acc) do
    type |> process_arg_type(acc) |> process_decoded_var_type()
  end

  defp process_decoded_var_type(%Type{encoded_type: 103, components: [component]}) do
    {type, access_keys} = process_decoded_var_type(component)
    {type, [%Type{size: 32, abi_name: "int256", encoded_type: 67} | access_keys]}
  end

  defp process_decoded_var_type(type) do
    {type, []}
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

    std_functions = generate_std_functions(compiler_state.used_standard_functions)

    user_defined_functions <> Enum.join(Map.values(std_functions), "\n")
  end

  defp generate_function(function, contract, compiler_state) do
    {last, other} = prepare_children(function.body)

    {ast, acc} =
      Macro.postwalk(
        other,
        %CompilerState{
          aliases: contract.aliases,
          storage_variables: contract.variables,
          used_standard_functions: compiler_state.used_standard_functions,
          events: contract.events
        },
        &expand_expression/2
      )

    {ast_last, acc} =
      Macro.postwalk(last, acc, &expand_expression/2)

    user_defined_functions =
      cond do
        function.typespec &&
            ((function.typespec.return && ast_last.return_values_count != 1) ||
               (!function.typespec.return && ast_last.return_values_count != 0)) ->
          raise "Typespec mismatches for #{function.name}!"

        (function.typespec && function.typespec.return && ast_last.return_values_count == 1) ||
          (!function.typespec && ast_last.return_values_count == 1) || true ->
          """
          function #{function.name}(#{Enum.map_join(function.args, ", ", &"_#{&1}")}) -> return_value_1$ {
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
            "return_value_1$ := #{ast_last.yul_snippet_usage}"
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

  defp generate_std_functions(used_std_functions, definitions \\ %{}) do
    Enum.reduce(used_std_functions, definitions, fn {function_name,
                                                     %StdFunction{yul: yul, deps: deps}},
                                                    definitions_acc ->
      {_, not_defined_deps} = Map.split(deps, Map.keys(definitions_acc))

      generate_std_functions(not_defined_deps, Map.put_new(definitions_acc, function_name, yul))
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
    yul_var_name = "_#{var_name}"

    {yul_snippet_left, declared_variables} =
      if MapSet.member?(declared_variables, var_name) do
        {"#{yul_var_name}", declared_variables}
      else
        {"let #{yul_var_name}", MapSet.put(declared_variables, var_name)}
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
         {%AuxiliaryNode{type: :function_call, value: {[Access], :get}}, _meta,
          [%AuxiliaryNode{type: :storage_variable} = storage_variable, index]},
         acc
       ) do
    {%AuxiliaryNode{
       storage_variable
       | access_keys: [index | storage_variable.access_keys]
     }, acc}
  end

  defp expand_expression(
         {%AuxiliaryNode{type: :function_call, value: value}, meta, args} = node,
         %CompilerState{uniqueness_provider: uniqueness_provider} = acc
       )
       when is_list(args) do
    case {value, Library.Utils.function_call_to_yul(value)} do
      {{modules, function_name}, :not_found} ->
        Module.concat(modules)
        raise "#{Module.concat(modules)}.#{function_name}/#{length(args)} is undefined"

      {function_name, :not_found} ->
        result_var_name = "$result$#{function_name}$#{uniqueness_provider}"

        args_definition =
          """
          #{Enum.map_join(args, "\n", fn yul_node -> yul_node.yul_snippet_definition end)}
          """

        {%YulNode{
           yul_snippet_definition:
             args_definition <>
               """
               let #{result_var_name} := #{function_name}(#{Enum.map_join(args, ", ", fn yul_node -> yul_node.yul_snippet_usage end)})
               offset$ = msize()
               """,
           yul_snippet_usage: "#{result_var_name}",
           meta: meta,
           elixir_initial: node,
           return_values_count: 1
         }, %CompilerState{acc | uniqueness_provider: uniqueness_provider + 1}}

      {_, library_fun} when is_function(library_fun, length(args) + 2) ->
        apply(library_fun, args ++ [acc, node])

      {{modules, function_name}, _} ->
        raise "#{Module.concat(modules)}.#{function_name}/#{length(args)} is undefined"

      {function_name, _} ->
        raise "#{function_name}/#{length(args)} is undefined"
    end
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

  defp expand_expression(
         {:., _meta, [module, function_name]},
         acc
       ) do
    {%AuxiliaryNode{
       type: :function_call,
       value: {[module.elixir_initial], function_name.elixir_initial}
     }, acc}
  end

  defp expand_expression({:__aliases__, _meta, yul_nodes}, %CompilerState{aliases: aliases} = acc) do
    prepared = prepare_aliases(aliases, Enum.map(yul_nodes, & &1.elixir_initial))
    {%AuxiliaryNode{type: :__aliases__, value: prepared}, acc}
  end

  defp expand_expression({:@, _meta, [%YulNode{elixir_initial: {var_name, _, nil}}]}, acc) do
    case Map.fetch(acc.storage_variables, var_name) do
      {:ok, var} ->
        {%AuxiliaryNode{type: :storage_variable, value: var}, acc}

      _ ->
        case Map.fetch(acc.events, var_name) do
          {:ok, event} -> {%AuxiliaryNode{type: :event, value: event}, acc}
          _ -> raise "@#{var_name} is not declared"
        end
    end
  end

  defp expand_expression({:__block__, _meta, children}, acc) do
    {children, acc}
  end

  #   defp expand_expression(
  #     {:sigil_ADDRESS, meta,
  #  _} = node,
  #     acc
  #   ) do
  # dbg()
  # end

  defp expand_expression(
         {:sigil_ADDRESS, _meta,
          [
            %YulNode{
              elixir_initial: {%AuxiliaryNode{value: :<<>>}, _, [%YulNode{value: address}]}
            } = _yul_node,
            %YulNode{elixir_initial: []}
          ]} = node,
         %CompilerState{uniqueness_provider: uniqueness_provider} = state
       ) do
    case Address.load(address) do
      {:ok, hash} ->
        var_name = "address#{state.uniqueness_provider}$"

        {%YulNode{
           value: hash,
           yul_snippet_definition: """
           let #{var_name} := offset$
           mstore8(offset$, #{Type.elixir_to_encoded_type(hash)})
           offset$ := add(offset$, 1)
           mstore(offset$, shl(#{8 * (32 - Type.elixir_to_size(hash))}, #{hash.hash}))
           offset$ := add(offset$, #{Type.elixir_to_size(hash)})
           """,
           yul_snippet_usage: var_name,
           return_values_count: 1,
           elixir_initial: node
         }, %CompilerState{state | uniqueness_provider: uniqueness_provider + 1}}

      :error ->
        raise "Address hash is invalid"
    end
  end

  # variable
  defp expand_expression({var, meta, nil} = other, %CompilerState{variables: _variables} = acc)
       when is_atom(var) do
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: "_#{var}",
       meta: meta,
       elixir_initial: other,
       return_values_count: 1
     }, acc}
  end

  defp expand_expression({function_name, meta, args}, acc)
       when is_atom(function_name) and is_list(args) do
    expand_expression(
      {%AuxiliaryNode{type: :function_call, value: function_name}, meta, args},
      acc
    )
  end

  defp expand_expression({_node, _meta, _} = other, _acc) do
    raise "Not implemented: #{inspect(other)}"
  end

  # todo: take care of not only literals
  defp expand_expression(list, acc) when is_list(list) do
    var_name = "list#{acc.uniqueness_provider}$"

    definition = """
    let #{var_name} := offset$
    mstore8(offset$, 103)
    offset$ := add(offset$, 1)
    mstore(offset$, #{Enum.count(list)})
    offset$ := add(offset$, 32)
    #{for i <- list do
      type = Type.elixir_to_encoded_type(i.value)
      """
      mstore8(offset$, #{type})
      offset$ := add(offset$, 1)
      mstore(offset$, #{i.value})
      offset$ := add(offset$, #{Type.elixir_to_size(i.value)})
      """
    end}
    """

    {%YulNode{
       yul_snippet_definition: definition,
       yul_snippet_usage: var_name,
       meta: nil,
       value: list,
       elixir_initial: list,
       return_values_count: 1
     }, %CompilerState{acc | uniqueness_provider: acc.uniqueness_provider + 1}}
  end

  defp expand_expression(str, acc) when is_binary(str) do
    var_name = "str#{acc.uniqueness_provider}$"

    words =
      str |> :binary.encode_hex() |> String.downcase() |> slice_string()

    definition = """
    let #{var_name} := offset$
    mstore8(offset$, 1)
    offset$ := add(offset$, 1)
    mstore(offset$, #{byte_size(str)})
    offset$ := add(offset$, 32)
    #{for {word, size} <- words do
      """
      mstore(offset$, #{word})
      offset$ := add(offset$, #{size})
      """
    end}

    """

    {%YulNode{
       yul_snippet_definition: definition,
       yul_snippet_usage: var_name,
       meta: nil,
       value: str,
       elixir_initial: str,
       return_values_count: 1
     }, %CompilerState{acc | uniqueness_provider: acc.uniqueness_provider + 1}}
  end

  defp expand_expression(atom, state) when is_boolean(atom) do
    var_name = "bool_var#{state.uniqueness_provider}$"

    definition = """
    let #{var_name} := offset$
    mstore8(offset$, #{Type.elixir_to_encoded_type(atom)})
    offset$ := add(offset$, 1)
    mstore(offset$, #{atom})
    offset$ := add(offset$, #{Type.elixir_to_size(atom)})
    """

    {%YulNode{
       yul_snippet_definition: definition,
       yul_snippet_usage: var_name,
       meta: nil,
       elixir_initial: atom,
       value: atom,
       return_values_count: 1
     }, %CompilerState{state | uniqueness_provider: state.uniqueness_provider + 1}}
  end

  defp expand_expression(atom, state) when is_atom(atom) do
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: "_#{atom}",
       meta: nil,
       elixir_initial: atom,
       return_values_count: 1
     }, state}
  end

  defp expand_expression(tuple, %CompilerState{} = state) when is_tuple(tuple) do
    {%YulNode{
       yul_snippet_definition: "",
       yul_snippet_usage: "",
       meta: nil,
       elixir_initial: tuple,
       return_values_count: 1,
       value: ""
     }, state}
  end

  defp expand_expression(other, %CompilerState{} = state) do
    var_name = "var#{state.uniqueness_provider}$"

    definition =
      """
      let #{var_name} := offset$
      mstore8(offset$, #{Type.elixir_to_encoded_type(other)})
      offset$ := add(offset$, 1)
      mstore(offset$, shl(#{8 * (32 - Type.elixir_to_size(other))}, #{other}))
      offset$ := add(offset$, #{Type.elixir_to_size(other)})
      """

    {%YulNode{
       yul_snippet_definition: definition,
       yul_snippet_usage: var_name,
       meta: nil,
       elixir_initial: other,
       return_values_count: 1,
       value: other
     }, %CompilerState{state | uniqueness_provider: state.uniqueness_provider + 1}}
  end

  defp prepare_aliases(aliases, [head | tail]) do
    (aliases[head] || [head]) ++ tail
  end

  defp slice_string(<<left::binary-size(64), remain::binary>>) do
    [{"0x" <> left, 32} | slice_string(remain)]
  end

  defp slice_string(str) do
    [{"0x" <> String.pad_trailing(str, 64, "0"), div(String.length(str), 2)}]
  end
end
