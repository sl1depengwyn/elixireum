defmodule Elixireum.YulCompiler do
  @version "v0.8.25+commit.b61c2a91"

  def compile(std_json) do
    with path <- download_compiler() do
      content =
        System.cmd(path, [
          "--standard-json",
          "--pretty-json",
          # "\"" <>
          std_json
          # <> "\""
        ])
        |> elem(0)

      content
    end
  end

  def download_compiler() do
    File.mkdir(compiler_dir())
    ensure_exists(@version)
  end

  def ensure_exists(version) do
    path = file_path(version)

    if File.exists?(path) do
      path
    else
      path = file_path(version)

      if fetch?(version, path) do
        temp_path = file_path("#{version}-tmp")

        contents = download(version)

        file = File.open!(temp_path, [:write, :exclusive])

        IO.binwrite(file, contents)

        File.rename(temp_path, path)

        if match?({:unix, _}, :os.type()) do
          System.cmd("chmod", ["+x", path])
        end

        path
      end
    end
  end

  defp file_path(version) do
    Path.join(compiler_dir(), "solc-#{os_type()}-#{version}")
  end

  defp compiler_dir do
    Application.app_dir(:elixireum, "solidity_compiler/")
  end

  defp os_type do
    case :os.type() do
      {:unix, :darwin} ->
        "macosx-amd64"

      {:unix, _} ->
        "solc-linux-amd64"

      {:win32, _} ->
        "windows-amd64"

      _ ->
        raise "Unknown OS"
    end
  end

  defp fetch?(_, path) do
    not File.exists?(path)
  end

  defp download(version) do
    download_path = "https://binaries.soliditylang.org/#{os_type()}/solc-#{os_type()}-#{version}"

    download_path
    |> HTTPoison.get!([], timeout: :infinity, recv_timeout: :infinity)
    |> Map.get(:body)
  end
end
