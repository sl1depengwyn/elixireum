# # https://docs.soliditylang.org/en/latest/abi-spec.html#types

# [_ | int_sizes] = 0..256//8 |> Range.to_list()
# bytes_sizes = 1..32 |> Range.to_list()
# precisions = 1..80

# simple_types = %{
#   UInt: 32,
#   Int: 32,
#   Fixed: 16,
#   UFixed: 16,
#   Address: 20,
#   Bool: 1,
#   Function: 24,
#   Bytes: :dynamic,
#   String: :dynamic
# }

# types =
#   int_sizes
#   |> Map.new(fn size -> {:"UInt#{size}", size |> div(8)} end)
#   |> Map.merge(int_sizes |> Map.new(fn size -> {:"Int#{size}", size |> div(8)} end))
#   |> Map.merge(bytes_sizes |> Map.new(fn size -> {:"Bytes#{size}", size} end))
#   |> Map.merge(Map.new(for m <- int_sizes, n <- precisions, do: {:"Fixed#{m}x#{n}", m |> div(8)}))
#   |> Map.merge(
#     Map.new(for m <- int_sizes, n <- precisions, do: {:"UFixed#{m}x#{n}", m |> div(8)})
#   )
#   |> Map.merge(simple_types)

# for {name, size} <- types do
#   defmodule Module.concat(Blockchain.Types, "#{name}") do
#     @type t :: nil

#     @behaviour Blockchain.Type
#     def size() do
#       unquote(size)
#     end
#   end
# end

# defmodule Blockchain.Types.Array do
#   @type t(elem_type, size) :: %{list: [elem_type], size: size}

#   @behaviour Blockchain.Type
#   def size() do
#     :dynamic
#   end
# end

# defmodule Blockchain.Types.Tuple do
#   @type t(tuple) :: %{tuple: [elem_type], size: :dynamic}
# end
