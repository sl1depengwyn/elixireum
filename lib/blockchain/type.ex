defmodule Blockchain.Type do
  @type t :: module()

  @spec size(t(), [atom() | tuple()]) :: {:ok, integer | :dynamic} | {:error, String.t()}
  def size(module, args) do
    module_name = module |> Atom.to_string()

    type_names = [
      "UInt",
      "Int",
      "Fixed",
      "UFixed",
      "Address",
      "Bool",
      "Function",
      "Bytes",
      "String",
      "Array",
      "Tuple"
    ]

    simple_type_sizes = %{
      "UInt" => 32,
      "Int" => 32,
      "Fixed" => 16,
      "UFixed" => 16,
      "Address" => 20,
      "Bool" => 1,
      "Function" => 24,
      "Bytes" => :dynamic,
      "String" => :dynamic
    }

    with ["Elixir", "Blockchain", "Types", type_with_size] <- String.split(module_name, "."),
         [type_name | type_size] <- String.split(type_with_size, simple_types) do
      cond do
        not is_nil(simple_type_sizes[type_name]) and type_size == [] ->
          {:ok, simple_type_sizes[type_name]}

        type_name in ~w(UInt Int) and length(type_size) == 1 ->
          int_size(List.first(type_size))

        type_name in ~w(UFixed Fixed) and length(type_size) == 1 ->
          fixed_size(List.first(type_size))

        type_name == "Bytes" and length(type_size) == 1 ->
          bytes_size(List.first(type_size))

        type_name == "Tuple" and type_size == [] ->
          tuple_size(args)

        type_name == "Array" and type_size == [] ->
          array_size(args)

        true ->
          {:error, "#{module} is unknown type"}
      end
    else
      _ -> {:error, "#{module} is unknown type"}
    end
  end

  defp int_size(size) do
  end

  defp fixed_size(size) do
  end

  defp bytes_size(size) do
  end

  defp array_size(args) do
  end

  defp tuple_size(args) do
  end
end
