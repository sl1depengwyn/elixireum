defmodule Mix.Tasks.Gen do
  use Mix.Task

  def run(command_line_args) do
    dbg(command_line_args)

    {parsed_args, mb_source_filename, _} =
      OptionParser.parse(command_line_args, strict: [out: :string, abi: :string])

    args =
      if Enum.count(mb_source_filename) == 1 do
        parsed_args
        |> Enum.into(%{source: Enum.at(mb_source_filename, 0)})
      else
        raise "usage: mix gen source_file"
      end

    with %{yul: yul, abi: abi} <-
           args
           |> Elixireum.Compiler.compile() do
      File.open!("./out.yul", [:write], fn file ->
        IO.write(file, yul)
      end)

      result = Elixireum.YulCompiler.compile("./out.yul")

      if Map.has_key?(args, :out) do
        File.open!(args[:out], [:write], fn file ->
          IO.write(file, result)
        end)
      end

      if Map.has_key?(args, :abi) do
        File.open!(args[:abi], [:write], fn file ->
          IO.write(file, abi |> Jason.encode_to_iodata!())
        end)
      end

      IO.puts(%{creation_bytecode: result, abi: abi} |> Jason.encode_to_iodata!())
    end
  end
end
