defmodule Elixireum.Compiler.Calldata do
  alias Blockchain.Type

  def decode(
        arg_name,
        %Type{
          encoded_type: 3,
          components: components,
          size: size
        } = type,
        data_load_fn,
        data_copy_fn,
        calldata_var,
        init_calldata_var
      ) do
    tail_offset_var_name = "#{calldata_var}$#{arg_name}"
    init_tail_offset_var_name = "#{init_calldata_var}$#{arg_name}_init"

    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)
    mstore(memory_offset$, #{Enum.count(components)})
    memory_offset$ := add(memory_offset$, 32)

    #{if size == :dynamic do
      """
      let #{tail_offset_var_name} := add(#{init_calldata_var}, #{data_load_fn}(#{calldata_var}))
      """
    else
      """
      let #{tail_offset_var_name} := #{calldata_var}
      """
    end}

    let #{init_tail_offset_var_name} := #{tail_offset_var_name}

    #{for {component, index} <- Enum.with_index(components) do
      decode(arg_name <> "#{index}", component, data_load_fn, data_copy_fn, tail_offset_var_name, init_tail_offset_var_name)
    end}
    """
  end

  def decode(
        arg_name,
        %Type{
          encoded_type: 103,
          items_count: items_count,
          components: [components],
          size: :dynamic
        } = type,
        data_load_fn,
        data_copy_fn,
        calldata_var,
        init_calldata_var
      ) do
    tail_offset_var_name = "#{calldata_var}$#{arg_name}"
    init_tail_offset_var_name = "#{init_calldata_var}$#{arg_name}init"
    list_length_var_name = "#{calldata_var}$#{arg_name}length"
    i = "#{arg_name}$#{init_calldata_var}i"

    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)

    let #{tail_offset_var_name} := add(#{init_calldata_var}, #{data_load_fn}(#{calldata_var}))

    #{case items_count do
      :dynamic -> """
        let #{list_length_var_name} := #{data_load_fn}(#{tail_offset_var_name})
        #{tail_offset_var_name} := add(#{tail_offset_var_name}, 32)
        """
      _ -> """
        let #{list_length_var_name} := #{items_count}
        """
    end}

    mstore(memory_offset$, #{list_length_var_name})
    memory_offset$ := add(memory_offset$, 32)

    let #{init_tail_offset_var_name} := #{tail_offset_var_name}

    for { let #{i} := 0 } lt(#{i}, #{list_length_var_name}) { #{i} := add(#{i}, 1) } {
      #{decode(arg_name, components, data_load_fn, data_copy_fn, tail_offset_var_name, init_tail_offset_var_name)}
    }

    #{calldata_var} := add(#{calldata_var}, 32)
    """
  end

  def decode(
        arg_name,
        %Type{encoded_type: 103, items_count: arr_size, components: [components]} = type,
        data_load_fn,
        data_copy_fn,
        calldata_var,
        _init_calldata_var
      ) do
    i = "#{arg_name}$#{calldata_var}i"

    init_calldata_var = "#{calldata_var}$#{arg_name}init"

    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)

    mstore(memory_offset$, #{arr_size})
    memory_offset$ := add(memory_offset$, 32)

    let #{init_calldata_var} := #{calldata_var}

    for { let #{i} := 0 } lt(#{i}, #{arr_size}) { #{i} := add(#{i}, 1) } {
      #{decode(arg_name, components, data_load_fn, data_copy_fn, calldata_var, init_calldata_var)}
    }
    """
  end

  # Bytes, String
  def decode(
        arg_name,
        %Type{encoded_type: encoded_type} = type,
        data_load_fn,
        data_copy_fn,
        calldata_var,
        init_calldata_var
      )
      when encoded_type in [1, 102] do
    tail_offset_var_name = "#{calldata_var}$#{arg_name}offset"
    length_var_name = "#{calldata_var}$#{arg_name}length"

    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)

    let #{tail_offset_var_name} := add(#{init_calldata_var}, #{data_load_fn}(#{calldata_var}))
    #{calldata_var} := add(#{calldata_var}, 32)

    let #{length_var_name} := #{data_load_fn}(#{tail_offset_var_name})
    #{tail_offset_var_name} := add(#{tail_offset_var_name}, 32)
    mstore(memory_offset$, #{length_var_name})
    memory_offset$ := add(memory_offset$, 32)

    #{data_copy_fn}(memory_offset$, #{tail_offset_var_name}, #{length_var_name})
    memory_offset$ := add(memory_offset$, #{length_var_name})
    """
  end

  # BytesN
  def decode(
        _arg_name,
        %Type{encoded_type: encoded_type} = type,
        data_load_fn,
        _data_copy_fn,
        calldata_var,
        _init_calldata_var
      )
      when encoded_type > 69 and encoded_type < 102 do
    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)
    mstore(memory_offset$, #{data_load_fn}(#{calldata_var}))
    memory_offset$ := add(memory_offset$, #{type.size})
    #{calldata_var} := add(#{calldata_var}, 32)
    """
  end

  def decode(
        _arg_name,
        %Type{} = type,
        data_load_fn,
        _data_copy_fn,
        calldata_var,
        _init_calldata_var
      ) do
    """
    mstore8(memory_offset$, #{type.encoded_type})
    memory_offset$ := add(memory_offset$, 1)
    mstore(memory_offset$, shl(#{8 * (32 - type.size)}, #{data_load_fn}(#{calldata_var})))
    memory_offset$ := add(memory_offset$, #{type.size})
    #{calldata_var} := add(#{calldata_var}, 32)
    """
  end
end
