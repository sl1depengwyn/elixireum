defmodule Elixireum.Compiler do
  @moduledoc """
  Elixireum Compiler
  """
  alias Blockchain.Storage
  alias Elixireum.{Contract, Function}

  def compile(_args) do
    :erlang.put(:elixir_parser_columns, true)
    :erlang.put(:elixir_token_metadata, true)
    :erlang.put(:elixir_literal_encoder, false)

    file_name = "./examples/storage.exm"

    code =
      file_name
      |> File.read!()

    {:ok, pid} = Kernel.LexicalTracker.start_link()

    %Contract{
      functions: functions_map,
      private_functions: private_functions_map,
      name: _,
      variables: _
    } =
      with {_, _, _, _, tokens} <-
             code
             |> String.to_charlist()
             |> :elixir_tokenizer.tokenize(0, 0, []),
           {_, ast} <- :elixir_parser.parse(tokens),
           {_ast, %{functions: functions, specs: _specs, private_functions: private_functions}} <-
             Macro.prewalk(
               ast,
               %{functions: [], specs: %{}, private_functions: []},
               &ast_to_contract_fields/2
             ) do
        functions_map = functions_list_to_functions_map(functions)
        private_functions_map = functions_list_to_functions_map(private_functions)

        %Contract{
          functions: functions_map,
          private_functions: private_functions_map,
          name: nil,
          variables: nil
        }
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
      #{generate_selector(acc)}

      #{generate_functions(Map.values(functions_map))}

      #{generate_functions(Map.values(private_functions_map))}
        }
      }
      }
      """

    File.open!("./out.yul", [:write], fn file ->
      IO.write(file, yul)
    end)
  end

  defp generate_selector(%{functions: functions}) do
    """
        let method_id := shr(0xe0, calldataload(0x0))
        switch method_id
    #{for function <- functions do
      <<method_id::binary-size(8), _::binary>> = function |> function_to_keccak_bytes() |> Base.encode16(case: :lower)
      {extraction, usage} = typed_function_to_arguments(function)
      """
            case 0x#{method_id} {
              #{extraction}
              let return_value := #{function.function_name}(#{usage})
              #{if function.typespec.return do
        """
        mstore(0, return_value)
        return(0, 32)
        """
      else
        """
        return(0, 0)
        """
      end}
            }
      """
    end}
    """
  end

  defp function_to_keccak_bytes(function) do
    function.function_name |> to_string() |> ExKeccak.hash_256()
  end

  defp typed_function_to_arguments(function) do
    {functions_extraction, _} =
      function.args
      |> Enum.zip(function.typespec.args)
      |> Enum.reduce({"", 0}, fn {arg, type}, {yul, offset} ->
        {yul <>
           """
           let #{arg} := calldataload(add(4, #{offset}))
           """, offset + type.size}
      end)

    {functions_extraction, function.args |> Enum.join(",")}
  end

  defp functions_list_to_functions_map(functions) do
    Enum.reduce(functions, %{}, fn function, acc ->
      Map.put(acc, function.name, function)
    end)
  end

  def ast_to_contract_fields({:@, _meta, [{:spec, _, spec_body}]} = node, acc) do
    {function_name, typespec} = process_spec_body(spec_body)
    {node, Map.put(acc, :specs, Map.put(acc[:specs], function_name, typespec))}
  end

  def ast_to_contract_fields({:def, _meta, children} = node, acc) do
    [{function_name, _, args} | body] = children
    # TODO add also check suitability of typespec by it's args

    function = %Function{
      name: function_name,
      typespec: fetch_spec(acc[:specs], function_name),
      body: body,
      args: extract_args(args)
    }

    {node, Map.put(acc, :functions, [function | acc[:functions]])}
  end

  def ast_to_contract_fields({:defp, _meta, children} = node, acc) do
    [{function_name, _, args} | body] = children
    # TODO add also check suitability of typespec by it's args

    function = %Function{
      name: function_name,
      body: body,
      args: extract_args(args)
    }

    {node, Map.put(acc, :private_functions, [function | acc[:private_functions]])}
  end

  def ast_to_contract_fields(other, acc) do
    {other, acc}
  end

  defp process_spec_body([{:"::", _meta, [{function_name, _meta_args, args} = _left, right]}]) do
    {function_name, %Typespec{args: process_args_types(args), return: right}}
  end

  defp process_args_types(args) do
    args
    |> Enum.map(&process_arg_type/1)
  end

  defp process_arg_type({:uint256, _, _} = raw) do
    %{size: 32, raw: raw}
  end

  defp process_arg_type(raw) do
    %{size: -1, raw: raw}
  end

  defp fetch_spec(specs, function_name) do
    if specs[function_name] do
      specs[function_name]
    else
      raise "You must define spec for public functions (`def`)! \n Couldn't find spec for #{function_name}"
    end
  end

  defp generate_functions(functions) do
    Enum.map(functions, &generate_function/1)
  end

  defp generate_function(function) do
    {last, other} = prepare_children(function.body)
    {ast, yul} = Macro.postwalk(other, "", &expand_expression/2)

    {ast, yul_} = Macro.postwalk(last, "", &prepare_last_statement/2)

    """
        function #{function.function_name}(#{Enum.join(function.args, ", ")}) -> return_value {

          #{yul}


          #{yul_}
        }
    """
  end

  defp prepare_children([[do: {:__block__, _, children}]]) do
    List.pop_at(children, -1)
  end

  defp prepare_children([[do: child]]) do
    {child, []}
  end

  @disallowed_actions_inside_function ~w(defmodule def defp)a

  defp expand_expression(_node, _acc, is_last \\ false)

  defp expand_expression({action, _, _}, _acc, _is_last)
       when action in @disallowed_actions_inside_function do
    raise "`#{action}` inside functions is not allowed!"
  end

  defp expand_expression({:=, _, [{var_name, _, _children}, value]} = node, acc, false) do
    {node, acc <> "let #{var_name} := #{Macro.to_string(value)}" <> "\n"}
  end

  defp expand_expression({:=, _, [{_var_name, _, _children}, value]} = node, acc, true) do
    {node, acc <> "let return_value := #{Macro.to_string(value)}" <> "\n"}
  end

  defp expand_expression(
         {{:., _, [{:__aliases__, _, [:BlockchainStorage]}, function_name]}, _, args} = node,
         acc,
         is_last
       ) do
    args =
      Enum.map(args, fn arg ->
        {ast, _acc} = Macro.postwalk(arg, "", &prepare_arg/2)
        ast
      end)

    %{yul_snippet: yul_snippet, returns_count: returns_count} =
      apply(Storage, function_name, args)

    if returns_count == 0 || is_last do
      {node, acc <> yul_snippet <> "\n"}
    else
      {node,
       "#{1..returns_count |> Enum.map(&"expr_#{&1}") |> Enum.join(", ")} := #{yul_snippet}\n}"}
    end
  end

  defp expand_expression(other, acc, _is_last) do
    {other, acc}
  end
end
