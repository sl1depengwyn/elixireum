defmodule Mix.Tasks.Gen do
  use Mix.Task

  def run(command_line_args) do
    {parsed_args, mb_source_filename, _} =
      OptionParser.parse(command_line_args, strict: [out: :string, abi: :string, sol: :boolean])

    args =
      if Enum.count(mb_source_filename) == 1 do
        parsed_args
        |> Enum.into(%{source: Enum.at(mb_source_filename, 0)})
      else
        raise "usage: mix gen source_file"
      end

    do_run(args[:source], args[:out], args[:abi], args[:sol])
  end

  defp do_run(source, out, _out_abi, true) do
    with {:ok, source} <- File.read(source) do
      std_json =
        %{
          language: "Solidity",
          sources: %{"contracts/in.sol": %{content: source}},
          settings: %{
            optimizer: %{enabled: true, runs: 1},
            outputSelection: %{
              *: %{
                "": ["ast"],
                *: [
                  "abi",
                  "metadata",
                  "devdoc",
                  "userdoc",
                  "storageLayout",
                  "evm.legacyAssembly",
                  "evm.bytecode",
                  "evm.deployedBytecode",
                  "evm.methodIdentifiers",
                  "evm.gasEstimates",
                  "evm.assembly"
                ]
              }
            },
            remappings: []
          }
        }
        |> Jason.encode_to_iodata!()

      File.open!("std.json", [:write], fn file ->
        IO.write(file, std_json)
      end)

      result =
        "std.json"
        |> Elixireum.YulCompiler.compile()

      if out do
        File.open!(out, [:write], fn file ->
          IO.write(file, result)
        end)
      end

      IO.puts(%{creation_bytecode: result} |> Jason.encode_to_iodata!())
    else
      _ -> raise "file not found: #{source}"
    end
  end

  defp do_run(source, out, out_abi, _) do
    with %{yul: yul, abi: abi} <-
           [source: source]
           |> Elixireum.Compiler.compile() do
      File.open!("./out.yul", [:write], fn file ->
        IO.write(file, yul)
      end)

      std_json =
        %{
          language: "Yul",
          sources: %{"contracts/in.yul": %{content: yul}},
          settings: %{
            optimizer: %{enabled: true, runs: 1},
            outputSelection: %{
              *: %{
                "": ["ast"],
                *: [
                  "abi",
                  "metadata",
                  "devdoc",
                  "userdoc",
                  "storageLayout",
                  "evm.legacyAssembly",
                  "evm.bytecode",
                  "evm.deployedBytecode",
                  "evm.methodIdentifiers",
                  "evm.gasEstimates",
                  "evm.assembly"
                ]
              }
            },
            remappings: []
          }
        }
        |> Jason.encode_to_iodata!()

      File.open!("std.json", [:write], fn file ->
        IO.write(file, std_json)
      end)

      result =
        "std.json"
        |> Elixireum.YulCompiler.compile()

      if out do
        File.open!(out, [:write], fn file ->
          IO.write(file, result)
        end)
      end

      if out_abi do
        File.open!(out_abi, [:write], fn file ->
          IO.write(file, abi |> Jason.encode_to_iodata!())
        end)
      end

      IO.puts(%{creation_bytecode: result, abi: abi} |> Jason.encode_to_iodata!())
    end
  end
end
