defmodule Mix.Tasks.Gen do
  use Mix.Task

  def run(command_line_args) do
    Elixireum.Compiler.compile(command_line_args)
  end
end
