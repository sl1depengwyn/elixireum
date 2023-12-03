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

    yul =
      code
      |> String.to_charlist()
      |> :elixir_tokenizer.tokenize(0, 0, [])
      |> elem(4)
      |> :elixir_parser.parse()
      |> elem(1)
      # |> :elixir_expand.expand(exEnv, env)
      |> Macro.postwalk(&expand/1)
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

    File.open!("./out.yul", [:write], fn file ->
      # IO.write(file, yul)
      IO.inspect(file, yul, limit: :infinity, printable_limit: :infinity)
    end)
  end

  def expand({:defmodule, meta, children} = node), do: node
  def expand({:@, meta, children} = node), do: node
  def expand({:def, meta, children} = node), do: node

  def expand(other), do: Macro.expand(other, __ENV__)
end
