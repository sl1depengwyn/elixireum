defmodule ETH.StorageA do
  require Macro

  defmacro ast_to_string do
    env = :elixir_env.new()

    quote do
        alias Blockchain.Types

        for x <- [1, 2, 3] do
          @spec String.to_atom("store_#{x}")() :: Types.Int256.t()
          def String.to_atom("get_#{x}")(), do: x
        end
    end
    |> Macro.expand(env)
    |> Macro.to_string()
  end
end

defmodule TTest do
  require ETH.StorageA

  def test do
    ETH.StorageA.ast_to_string()
  end

  # def expand_test do
  #   code = File.read!("examples/storage.exm")
  #   {:ok, ast} = Code.string_to_quoted(code)

  #   no_tail_optimize = fn meta, ast ->
  #     {:__block__, meta,
  #      [
  #        {:=, meta, [{:result, meta, ETH.StorageA}, ast]},
  #        {{:., meta, [:elixir_utils, :noop]}, meta, []},
  #        {:result, meta, ETH.StorageA}
  #      ]}
  #   end

  #   env = :elixir_env.new()

  #   escaped =
  #     case env do
  #       %{function: nil, lexical_tracker: pid} when is_pid(pid) ->
  #         integer = Kernel.LexicalTracker.write_cache(pid, block)
  #         quote(do: Kernel.LexicalTracker.read_cache(unquote(pid), unquote(integer)))

  #       %{} ->
  #         :elixir_quote.escape(block, :none, false)
  #     end

  #   versioned_vars = env.versioned_vars
  #   prune = :erlang.is_map_key({:elixir, :prune_binding}, versioned_vars)

  #   var_meta =
  #     case prune do
  #       true -> [generated: true, keep_unused: true]
  #       false -> [generated: true]
  #     end

  #   module_vars = :lists.map(&module_var(&1, var_meta), :maps.keys(versioned_vars))

  #   :elixir_lexical.run(
  #     env,
  #     fn lexical_env ->
  #       :elixir_expand.expand(no_tail_optimize.([], ast), :elixir_env.env_to_ex(env), env)
  #     end,
  #     fn _ -> :ok end
  #   )
  # end
end
