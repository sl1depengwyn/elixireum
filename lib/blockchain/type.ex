defmodule Blockchain.Type do
  alias Blockchain.Address

  @type t :: %__MODULE__{
          size: non_neg_integer() | :dynamic,
          abi_name: String.t(),
          encoded_type: pos_integer(),
          components: [t()],
          items_count: non_neg_integer() | :dynamic
        }

  defstruct [:size, :abi_name, :encoded_type, :components, :items_count]

  def elixir_to_encoded_type(t) do
    case t do
      %Address{} -> 68
      t when is_binary(t) -> 1
      t when is_boolean(t) -> 2
      # t when is_float(t) -> 3
      t when is_integer(t) -> 67
      t when is_list(t) -> 103
      t when is_tuple(t) -> 3
    end
  end

  def elixir_to_size(t) when is_boolean(t), do: 1
  def elixir_to_size(%Address{}), do: 20
  def elixir_to_size(_t), do: 32

  @spec from_module([module()], [atom() | tuple()]) :: {:ok, t()} | {:error, String.t()}
  def from_module(modules, args) do
    modules_name = modules |> Enum.map(&Atom.to_string/1)

    type_names = [
      "UInt",
      "Int",
      # "Fixed",
      # "UFixed",
      "Address",
      "Bool",
      "Function",
      "Bytes",
      "String",
      "Array",
      "Tuple"
    ]

    simple_type_sizes = %{
      "Address" => 20,
      "Bool" => 1,
      "Function" => 24,
      "Bytes" => :dynamic,
      "String" => :dynamic
    }

    splitter = Regex.compile!(Enum.join(type_names, "|"))

    with ["Blockchain", "Types", type_with_size] <- modules_name,
         [type_name | type_size] <-
           String.split(type_with_size, splitter, include_captures: true, trim: true) do
      cond do
        not is_nil(simple_type_sizes[type_name]) and type_size == [] ->
          abi_name = String.downcase(type_name)

          {:ok,
           %__MODULE__{
             size: simple_type_sizes[type_name],
             abi_name: String.downcase(type_name),
             encoded_type: abi_name_to_encoded_type(abi_name)
           }}

        type_name in ~w(UInt Int) and length(type_size) == 1 ->
          int_type(type_name, List.first(type_size))

        # type_name in ~w(UFixed Fixed) and length(type_size) == 1 ->
        #   fixed_type(type_name, List.first(type_size))

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
        abi_name = String.downcase(type_name) <> size

        {:ok,
         %__MODULE__{
           size: int_size |> div(8),
           abi_name: abi_name,
           encoded_type: abi_name_to_encoded_type(abi_name)
         }}

      _ ->
        {:error, "invalid size for integer type: #{size}"}
    end
  end

  defp _fixed_type(type_name, size) do
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
        abi_name = "bytes#{size}"

        {:ok,
         %__MODULE__{
           size: int_size,
           abi_name: abi_name,
           encoded_type: abi_name_to_encoded_type(abi_name)
         }}

      _ ->
        {:error, "invalid size for bytes type: #{size}"}
    end
  end

  defp array_type([component, size]) when size == :dynamic or is_integer(size) do
    case size do
      :dynamic ->
        {:ok,
         %__MODULE__{
           size: :dynamic,
           abi_name: component.abi_name <> "[]",
           components: [component],
           encoded_type: 103,
           items_count: :dynamic
         }}

      size when is_integer(size) ->
        {:ok,
         %__MODULE__{
           size: if(is_integer(component.size), do: component.size * size, else: component.size),
           abi_name: component.abi_name <> "[#{size}]",
           components: [component],
           encoded_type: 103,
           items_count: size
         }}
    end
  end

  defp array_type(args) do
    {:error,
     "invalid array type args, expected components size and size (integer or :dynamic): #{inspect(args)}"}
  end

  defp tuple_type(args) do
    size =
      Enum.reduce(args, 0, fn
        arg, acc ->
          case {arg.size, acc} do
            {arg_size, acc_size} when is_integer(arg_size) and is_integer(acc_size) ->
              arg_size + acc_size

            _ ->
              :dynamic
          end
      end)

    {:ok,
     %__MODULE__{
       size: size,
       abi_name: "tuple",
       components: args,
       encoded_type: 3,
       items_count: Enum.count(args)
     }}
  end

  defp abi_name_to_encoded_type(abi_name) do
    if abi_name |> String.ends_with?("]") do
      103
    else
      case abi_name do
        "string" ->
          1

        "bool" ->
          2

        # tuple
        "(" <> _ ->
          3

        "uint" <> size ->
          {int_size, ""} = Integer.parse(size)
          3 + (int_size |> div(8))

        "int" <>
            size ->
          {int_size, ""} = Integer.parse(size)
          35 + (int_size |> div(8))

        "address" ->
          68

        "function" ->
          69

        "bytes" <> size ->
          {int_size, ""} = Integer.parse(size)
          69 + int_size

        "bytes" ->
          102
      end
    end
  end
end
