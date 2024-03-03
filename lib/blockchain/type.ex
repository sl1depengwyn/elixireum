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
         [type_name | type_size] <- String.split(type_with_size, type_names) do
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
          size_of_tuple(args)

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
    case Integer.parse(size) do
      {int_size, ""} when int_size > 0 and int_size <= 256 and int_size |> rem(8) == 0 ->
        {:ok, int_size |> div(8)}

      _ ->
        {:error, "invalid size for integer type: #{size}"}
    end
  end

  defp fixed_size(size) do
    with [m, n] <- String.split(size, "x"),
         {int_m, ""} when int_m >= 8 and int_m <= 256 and int_m |> rem(8) == 0 <-
           Integer.parse(m),
         {int_n, ""} when int_n > 0 and int_n <= 80 <- Integer.parse(n) do
      {:ok, int_m |> div(8)}
    else
      _ ->
        {:error, "invalid size for fixed type: #{size}"}
    end
  end

  defp bytes_size(size) do
    case Integer.parse(size) do
      {int_size, ""} when int_size > 0 and int_size <= 32 ->
        {:ok, int_size}
    end
  end

  defp array_size(args) do
    # TODO
  end

  defp size_of_tuple(args) do
    # TODO
  end
end
