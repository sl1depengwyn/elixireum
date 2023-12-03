defmodule Mix.Tasks.Gen do
  use Mix.Task

  alias Elixireum

  def run(command_line_args) do
    Elixireum.compile(command_line_args)
  end
end
