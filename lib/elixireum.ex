# defmodule Macros do
#   defmacro good(param) do
#     IO.inspect(param, label: "👍 Passed")
#     expanded = Macro.expand(param, __CALLER__ |> Map.from_struct() |> dbg(limit: :infinity, printable_limit: :infinity))
#     IO.inspect(expanded, label: "👍 Expanded")
#   end

#   defmacro bad(param) do
#     IO.inspect(param, label: "👎 Not Expanded")
#   end
# end

defmodule Elixireum do
  @moduledoc """
  Documentation for `Elixireum`.
  """
  @doc """
  Hello world.

  ## Examples

      iex> Elixireum.hello()
      :world

  """

  # import Macros
  # @data_types [:x, :y, :z]
  # @asd 123

  # def asd(_args) do
  #   good(@data_types)
  #   bad(@data_types)
  # end

  def compile(_args) do
    :erlang.put(:elixir_parser_columns, true)
    :erlang.put(:elixir_token_metadata, true)
    :erlang.put(:elixir_literal_encoder, false)

    file_name = "./examples/storage.exm"

    code =
      file_name
      |> File.read!()

    # env = :elixir_env.new() |> dbg()

    # Code.compile_file(file_name)

    # Get the module's environment after compilation
    # [{module, _binary}] = Code.require_file(file_name)
    # env = module.module_info() |> Map.fetch!(:compile) |> Keyword.fetch!(:env) |> dbg()
    # exEnv = :elixir_env.env_to_ex(env) |> dbg()

    {:ok, pid} = Kernel.LexicalTracker.start_link()

    {ast, acc} =
      code
      |> String.to_charlist()
      |> :elixir_tokenizer.tokenize(0, 0, [])
      |> elem(4)
      |> :elixir_parser.parse()
      |> elem(1)
      # |> :elixir_expand.expand(exEnv, env)
      |> Macro.prewalk(%{functions: [], specs: []}, &expand/2)

    # |> Macro.to_string()

    # quote do
    #   defmodule Test do
    #     @asd 123

    #     def a() do
    #       @asd
    #     end
    #   end
    # end
    # |> Macro.prewalk(&Macro.expand(&1, %Macro.Env{__ENV__| lexical_tracker:  pid}))

    yul =
      """
      object "contract" {
        code { }
        object "runtime" {
      #{generate_selector(acc)}

      #{generate_functions(acc)}
        }
      }
      """
      |> dbg()

    File.open!("./out.yul", [:write], fn file ->
      # IO.write(file, yul)
      IO.inspect(file, ast, limit: :infinity, printable_limit: :infinity)
    end)
  end

  # def expand(node, int) do
  #   {node, int + 1} |> dbg()
  #   # case  node  do
  #   #   {:defmodule, _, _} -> :xyz
  #   #   other -> other
  #   # end

  # end

  @ignored_nodes ~w(defmodule @ def defp)a

  def expand({:@, _meta, [{:spec, _, spec_body}]} = node, acc) do
    {node, Map.put(acc, :specs, [process_spec_body(spec_body) | acc[:specs]])}
  end

  def expand({:def, _meta, children} = node, acc) do
    [{function_name, _, _args} | body] = children
    # TODO add also check suitability of typespec by it's args

    function = %YulFunction{
      typespec: fetch_spec(acc[:specs], function_name),
      body: Macro.expand(body, __ENV__)
    }

    {node, Map.put(acc, :functions, [function | acc[:functions]])}
  end

  def expand({ignored, _meta, _children} = node, acc) when ignored in @ignored_nodes,
    do: {node, acc}

  def expand(other, acc), do: {Macro.expand(other, __ENV__), acc}

  defp process_spec_body([{:"::", _meta, [{function_name, _meta_args, args} = _left, right]}]) do
    %Typespec{function_name: function_name, args: args, return: right}
  end

  defp fetch_spec([%Typespec{function_name: function_name} = spec | _], function_name), do: spec

  defp fetch_spec(specs, function_name) do
    dbg(specs)

    raise "You must define spec for public functions (`def`)! \n Couldn't find spec for #{function_name}"
  end

  defp generate_selector(%{functions: functions}) do
    """
        let _2 := shr(0xe0, calldataload(0x0))
        switch _2
          #{for function <- functions do
      """
        case #{function_to_keccak_bytes(function)} {
          #{function.typespec.function_name}()
        }
      """
    end}
    """
  end

  defp function_to_keccak_bytes(function) do
    "0x00000000"
  end

  defp generate_functions(%{functions: functions}) do
    Enum.map(functions, &generate_function/1)
  end

  defp generate_function(function) do
    """
        function #{function.typespec.function_name}() {
          #{Macro.to_string(function.body)}
        }
    """
  end
end
