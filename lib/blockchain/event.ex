defmodule Blockchain.Event do
  alias Elixireum.{AuxiliaryNode, Compiler, CompilerState, YulNode}
  alias Elixireum.Compiler.Return
  alias Blockchain.Type

  @type t :: %__MODULE__{
          name: atom(),
          indexed_arguments: [keyword(Type.t())],
          data_arguments: [keyword(Type.t())],
          keccak256: String.t()
        }

  defstruct [:name, :indexed_arguments, :data_arguments, :keccak256]

  def emit(
        %AuxiliaryNode{
          type: :event,
          value: %__MODULE__{
            name: name,
            data_arguments: data_arguments,
            indexed_arguments: indexed_arguments,
            keccak256: event_keccak256
          }
        },
        %YulNode{elixir_initial: values},
        %CompilerState{} = state,
        node
      ) do
    values =
      for %YulNode{elixir_initial: {key, value}} <- values do
        {key.elixir_initial, value}
      end

    indexed_topics =
      for {key, type} <- indexed_arguments do
        value = Keyword.fetch!(values, key)
        {definition, usage} = encode_indexed_argument(key, type, value)

        {value.yul_snippet_definition <> definition, usage}
      end

    definition =
      (data_arguments
       |> Enum.reduce("", fn {key, _type}, acc ->
         value = Keyword.fetch!(values, key)

         acc <> value.yul_snippet_definition
       end)) <>
        """
        //let indexed_data_init$ := msize()
        //let indexed_data$ := indexed_data_init$
        //indexed_data$ := add(indexed_data$, #{Enum.count(data_arguments) * 32})
        let return_value$ := 0
        let processed_return_value$ := msize()
        let processed_return_value_init$ := processed_return_value$
        processed_return_value$ := add(processed_return_value$, #{Enum.count(data_arguments) * 32})
        """

    data_args_definition =
      data_arguments
      |> Enum.with_index()
      |> Enum.reduce(definition, fn {{key, type}, index}, acc ->
        value = Keyword.fetch!(values, key)

        definition = encode_data_argument(key, type, value, index)

        acc <> definition
      end)

    {yul_snippet_usage, yul_snippet_definition} =
      case indexed_topics do
        [] ->
          {"""
           log1(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$), #{event_keccak256})
           """, data_args_definition}

        [{t1_def, t1_usage}] ->
          {"""
           log2(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$), #{event_keccak256}, #{t1_usage})
           """,
           """
           #{t1_def}
           #{data_args_definition}
           """}

        [{t1_def, t1_usage}, {t2_def, t2_usage}] ->
          {"""
           log3(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$), #{event_keccak256}, #{t1_usage}, #{t2_usage})
           """,
           """
           #{t1_def}
           #{t2_def}
           #{data_args_definition}
           """}

        [{t1_def, t1_usage}, {t2_def, t2_usage}, {t3_def, t3_usage}] ->
          {"""
           log4(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$), #{event_keccak256}, #{t1_usage}, #{t2_usage}, #{t3_usage})
           """,
           """
           #{t1_def}
           #{t2_def}
           #{t3_def}
           #{data_args_definition}
           """}

        _ ->
          raise "Too many indexed topics (> 3) in event #{name}"
      end

    {%YulNode{
       yul_snippet_usage: yul_snippet_usage,
       yul_snippet_definition: yul_snippet_definition,
       return_values_count: 0,
       elixir_initial: node
     }, state}
  end

  def new(
        %{name: name, indexed_arguments: indexed_arguments, data_arguments: data_arguments} =
          fields
      ) do
    %__MODULE__{
      name: name,
      indexed_arguments: indexed_arguments,
      data_arguments: data_arguments,
      keccak256: keccak256(fields)
    }
  end

  defp keccak256(%{
         name: name,
         indexed_arguments: indexed_arguments,
         data_arguments: data_arguments
       }) do
    keccak256 =
      "#{name}(#{(indexed_arguments ++ data_arguments) |> Enum.map(&elem(&1, 1)) |> Enum.map_join(",", &Compiler.do_function_to_keccak_bytes/1)})"
      |> ExKeccak.hash_256()
      |> Base.encode16(case: :lower)

    "0x" <> keccak256
  end

  defp encode_indexed_argument(
         arg_name,
         %Type{encoded_type: encoded_type} = type,
         %YulNode{yul_snippet_usage: yul_snippet_usage}
       )
       when encoded_type not in [1, 3, 102, 103] do
    var_name = "indexed_#{arg_name}_keccak_var$"
    arg_name_pointer = "indexed_#{arg_name}_pointer$"

    {"""
     let #{arg_name_pointer} := #{yul_snippet_usage}
     switch byte(0, mload(#{arg_name_pointer}))
       case #{encoded_type} {}
       default {
         revert(0, 0)
       }

     #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
     let #{var_name} := shr(#{8 * (32 - type.size)}, mload(#{arg_name_pointer}))
     """, var_name}
  end

  defp encode_indexed_argument(
         arg_name,
         %Type{} = type,
         %YulNode{yul_snippet_usage: yul_snippet_usage}
       ) do
    init_var_name = "indexed_#{arg_name}_keccak_init$"
    var_name = "indexed_#{arg_name}_keccak_var$"
    arg_name_pointer = "indexed_#{arg_name}_pointer$"

    {"""
     let #{init_var_name} := offset$
     let #{arg_name_pointer} := #{yul_snippet_usage}
     #{do_encode_indexed_argument(type, arg_name_pointer, init_var_name, 0)}
     let #{var_name} := keccak256(#{init_var_name}, sub(offset$, #{init_var_name}))
     """, var_name}
  end

  defp do_encode_indexed_argument(
         %Type{encoded_type: 103, components: [component]} = type,
         arg_name_pointer,
         init_var_name,
         uniqueness_provider
       ) do
    size = "size_of_#{arg_name_pointer}_#{uniqueness_provider}$"
    i = "i_#{arg_name_pointer}#{uniqueness_provider}$"

    """
      switch byte(0, mload(#{arg_name_pointer}))
        case #{type.encoded_type} {}
        default {revert(0, 0)}

      #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
      let #{size} := mload(#{arg_name_pointer})
      #{arg_name_pointer} := add(#{arg_name_pointer}, 32)

      for {let #{i} := 0} lt(#{i}, #{size})
      {
        #{i} := add(#{i}, 1)
      }
      {
        #{do_encode_indexed_argument(component, arg_name_pointer, init_var_name, uniqueness_provider + 1)}
        offset$ := add(#{init_var_name}, mul(32, add(1, div(sub(sub(offset$, #{init_var_name}), 1), 32))))
      }
    """
  end

  defp do_encode_indexed_argument(
         %Type{encoded_type: 3, components: components, items_count: items_count} = type,
         arg_name_pointer,
         init_var_name,
         uniqueness_provider
       ) do
    size = "size_of_#{arg_name_pointer}#_#{uniqueness_provider}$"

    """
      switch byte(0, mload(#{arg_name_pointer}))
        case #{type.encoded_type} {}
        default {revert(0, 0)}

      #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
      let #{size} := mload(#{arg_name_pointer})
      #{arg_name_pointer} := add(#{arg_name_pointer}, 32)

      switch #{size}
        case #{items_count} {}
        default {revert(0, 0)}

      #{for {j, type} <- Enum.with_index(components) do
      do_encode_indexed_argument(type, arg_name_pointer, init_var_name, uniqueness_provider + j + 1) <> """
      offset$ := add(#{init_var_name}, mul(32, add(1, div(sub(sub(#{init_var_name}, offset$), 1), 32))))
      """
    end}
    """
  end

  defp do_encode_indexed_argument(
         %Type{encoded_type: encoded_type} = type,
         arg_name_pointer,
         _init_var_name,
         uniqueness_provider
       )
       when encoded_type in [1, 102] do
    size = "size_of_#{arg_name_pointer}#_#{uniqueness_provider}$"

    """
      switch byte(0, mload(#{arg_name_pointer}))
        case #{type.encoded_type} {}
        default {revert(0, 0)}

      #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
      let #{size} = mload(#{arg_name_pointer})

      #{arg_name_pointer} := add(#{arg_name_pointer}, 32)

      mcopy(offset$, #{arg_name_pointer}, #{size})
      #{arg_name_pointer} := add(#{arg_name_pointer}, #{size})
      offset$ := add(offset$, #{size})
    """
  end

  defp do_encode_indexed_argument(
         %Type{encoded_type: encoded_type} = type,
         arg_name_pointer,
         _init_var_name,
         _uniqueness_provider
       )
       when encoded_type > 69 and encoded_type < 102 do
    offset = 8 * (32 - type.size)

    """
      switch byte(0, mload(#{arg_name_pointer}))
        case #{type.encoded_type} {}
        default {revert(0, 0)}

      #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
      mstore(offset$, shl(#{offset}, shr(#{offset}}, mload(#{arg_name_pointer}))))
      offset$ := add(offset$, 32)
      #{arg_name_pointer} := add(#{arg_name_pointer}, #{type.size})
    """
  end

  defp do_encode_indexed_argument(
         %Type{encoded_type: encoded_type} = type,
         arg_name_pointer,
         _init_var_name,
         _uniqueness_provider
       ) do
    """
      switch byte(0, mload(#{arg_name_pointer}))
        case #{encoded_type} {}
        default {revert(0, 0)}

      #{arg_name_pointer} := add(#{arg_name_pointer}, 1)
      mstore(offset$, shr(#{8 * (32 - type.size)}, mload(#{arg_name_pointer})))
      offset$ := add(offset$, 32)
      #{arg_name_pointer} := add(#{arg_name_pointer}, #{type.size})
    """
  end

  defp encode_data_argument(
         arg_name,
         %Type{} = type,
         %YulNode{yul_snippet_usage: yul_snippet_usage},
         index
       ) do
    """
    let #{arg_name}_$ := processed_return_value$
    let #{arg_name}_init$ := #{arg_name}_$
    let #{arg_name}_where_to_store_head$ := add(processed_return_value_init$, #{index * 32})
    let #{arg_name}_where_to_store_head_init$ := #{arg_name}_where_to_store_head$
    return_value$ := #{yul_snippet_usage}
    #{Return.encode(type, "i$", "size$", "#{arg_name}_where_to_store_head$", "#{arg_name}_where_to_store_head_init$")}
    // processed_return_value$ := add(processed_return_value$, 32)
    // return(processed_return_value_init$, sub(processed_return_value$, processed_return_value_init$))
    """
  end
end
