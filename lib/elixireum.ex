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
  def hello do

    :erlang.put(:elixir_parser_columns, true)
    :erlang.put(:elixir_token_metadata, true)
    :erlang.put(:elixir_literal_encoder, false)

    "./lib/test.ex"
    |> File.read!()
    |> String.to_charlist()
    |> :elixir_tokenizer.tokenize(0, 0, [])
    |> elem(4)
    |> :elixir_parser.parse()
    |> dbg()
  end
end
