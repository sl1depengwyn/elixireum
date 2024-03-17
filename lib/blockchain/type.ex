defmodule Blockchain.Type do
  @type t :: %__MODULE__{size: non_neg_integer() | :dynamic, abi_name: String.t()}

  defstruct [:size, :abi_name]

  @spec from_module([module()], [atom() | tuple()]) :: {:ok, t()} | {:error, String.t()}
  def from_module(modules, args) do
    modules_name = modules |> Enum.map(&Atom.to_string/1) |> dbg()

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

    splitter = Regex.compile!(Enum.join(type_names, "|"))

    with ["Blockchain", "Types", type_with_size] <- modules_name,
         [type_name | type_size] <-
           String.split(type_with_size, splitter, include_captures: true, trim: true) |> dbg() do
      cond do
        not is_nil(simple_type_sizes[type_name]) and type_size == [] ->
          {:ok,
           %__MODULE__{size: simple_type_sizes[type_name], abi_name: String.downcase(type_name)}}

        type_name in ~w(UInt Int) and length(type_size) == 1 ->
          int_type(type_name, List.first(type_size))

        type_name in ~w(UFixed Fixed) and length(type_size) == 1 ->
          fixed_type(type_name, List.first(type_size))

        type_name == "Bytes" and length(type_size) == 1 ->
          bytes_type(List.first(type_size))

        type_name == "Tuple" and type_size == [] ->
          tuple_type(args)

        type_name == "Array" and type_size == [] ->
          array_type(args)

        true ->
          {:error, "#{inspect(modules_name)} is unknown type"}
      end
    else
      _ -> {:error, "#{inspect(modules_name)} is unknown type"}
    end
  end

  defp int_type(type_name, size) do
    case Integer.parse(size) do
      {int_size, ""} when int_size > 0 and int_size <= 256 and int_size |> rem(8) == 0 ->
        {:ok, %__MODULE__{size: int_size |> div(8), abi_name: String.downcase(type_name) <> size}}

      _ ->
        {:error, "invalid size for integer type: #{size}"}
    end
  end

  defp fixed_type(type_name, size) do
    with [m, n] <- String.split(size, "x"),
         {int_m, ""} when int_m >= 8 and int_m <= 256 and int_m |> rem(8) == 0 <-
           Integer.parse(m),
         {int_n, ""} when int_n > 0 and int_n <= 80 <- Integer.parse(n) do
      {:ok,
       %__MODULE__{size: int_m |> div(8), abi_name: "#{String.downcase(type_name)}#{m}x#{n}"}}
    else
      _ ->
        {:error, "invalid size for fixed type: #{size}"}
    end
  end

  defp bytes_type(size) do
    case Integer.parse(size) do
      {int_size, ""} when int_size > 0 and int_size <= 32 ->
        {:ok, %__MODULE__{size: int_size, abi_name: "bytes#{size}"}}

      _ ->
        {:error, "invalid size for bytes type: #{size}"}
    end
  end

  defp array_type(args) do
    # TODO
  end

  defp tuple_type(args) do
    # TODO
  end
end
