defmodule Elixireum.Compiler.Return do
  alias Blockchain.Type
  alias Elixireum.Library.Utils

  def encode(
        %Type{encoded_type: 3 = encoded_type, components: components} = type,
        i_var_name,
        _size_var_name,
        where_to_store_head_var_name,
        where_to_store_head_init_var_name
      ) do
    where_to_store_children_heads_var_name = "#{where_to_store_head_var_name}#{i_var_name}_$"

    where_to_store_children_heads_init_var_name =
      "#{where_to_store_head_init_var_name}#{i_var_name}_$"

    """
    #{Utils.generate_type_check("return_value$", encoded_type, "Wrong type for return value, expected tuple", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)

    #{Utils.generate_value_check("mload(return_value$)", Enum.count(components), "Wrong size of tuple for return value, expected #{Enum.count(components)}", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 32)

    let #{where_to_store_children_heads_var_name} := processed_return_value$
    let #{where_to_store_children_heads_init_var_name} := #{where_to_store_children_heads_var_name}

    #{if type.size == :dynamic do
      """
      mstore(#{where_to_store_head_var_name}, sub(processed_return_value$, #{where_to_store_head_init_var_name}))
      #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)
      processed_return_value$ := add(processed_return_value$, #{components |> Enum.map(&type_to_head_size/1) |> Enum.sum()})
      """
    end}

    #{for {component, index} <- Enum.with_index(components) do
      encode(component, "i$#{index}", "size$#{index}", where_to_store_children_heads_var_name, where_to_store_children_heads_init_var_name)
    end}
    """
  end

  def encode(
        %Type{
          encoded_type: 103 = encoded_type,
          items_count: items_count,
          size: :dynamic,
          components: [components]
        },
        i_var_name,
        size_var_name,
        where_to_store_head_var_name,
        where_to_store_head_init_var_name
      ) do
    where_to_store_children_heads_var_name = "#{where_to_store_head_var_name}#{i_var_name}_$"

    where_to_store_children_heads_init_var_name =
      "#{where_to_store_head_init_var_name}#{i_var_name}_$"

    """

    #{Utils.generate_type_check("return_value$", encoded_type, "Wrong type for return value, expected array", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)

    let #{size_var_name} := mload(return_value$)
    return_value$ := add(return_value$, 32)

    #{if items_count != :dynamic do
      """
      #{Utils.generate_value_check(size_var_name, items_count, "Wrong length for static array, expected #{items_count}", Enum.random(1_000_000..2_000_000))}
      """
    end}

    mstore(#{where_to_store_head_var_name}, sub(processed_return_value$, #{where_to_store_head_init_var_name}))
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)

    #{if items_count == :dynamic do
      """
      mstore(processed_return_value$, #{size_var_name})
      processed_return_value$ := add(processed_return_value$, 32)
      """
    end}

    let #{where_to_store_children_heads_var_name} := processed_return_value$
    let #{where_to_store_children_heads_init_var_name} := #{where_to_store_children_heads_var_name}

    processed_return_value$ := add(processed_return_value$, mul(#{size_var_name}, #{type_to_head_size(components)}))

    for { let #{i_var_name} := 0 } lt(#{i_var_name}, #{size_var_name}) { #{i_var_name} := add(#{i_var_name}, 1) } {
      #{encode(components, i_var_name <> "_", size_var_name <> "_", where_to_store_children_heads_var_name, where_to_store_children_heads_init_var_name)}
    }
    """
  end

  def encode(
        %Type{
          encoded_type: 103 = encoded_type,
          items_count: size,
          components: [components]
        },
        i_var_name,
        size_var_name,
        where_to_store_head_var_name,
        where_to_store_head_init_var_name
      )
      when is_integer(size) do
    """
    #{Utils.generate_type_check("return_value$", encoded_type, "Wrong type for return value, expected array", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)
    let #{size_var_name} := mload(return_value$)

    #{Utils.generate_value_check(size_var_name, size, "Wrong length for static array, expected #{size}", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 32)

    for { let #{i_var_name} := 0 } lt(#{i_var_name}, #{size_var_name}) { #{i_var_name} := add(#{i_var_name}, 1) } {
      #{encode(components, i_var_name <> "_", size_var_name <> "_", where_to_store_head_var_name, where_to_store_head_init_var_name)}
    }
    """
  end

  # Bytes, String
  def encode(
        %Type{encoded_type: encoded_type},
        _i_var_name,
        size_var_name,
        where_to_store_head_var_name,
        where_to_store_head_init_var_name
      )
      when encoded_type in [1, 102] do
    """
    #{Utils.generate_type_check("return_value$", encoded_type, "Wrong type for return value, expected bytes or string", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)

    mstore(#{where_to_store_head_var_name}, sub(processed_return_value$, #{where_to_store_head_init_var_name}))
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)

    let #{size_var_name} := mload(return_value$)
    return_value$ := add(return_value$, 32)

    mstore(processed_return_value$, #{size_var_name})
    processed_return_value$ := add(processed_return_value$, 32)

    mcopy(processed_return_value$, return_value$, #{size_var_name})
    processed_return_value$ := add(processed_return_value$, mul(32, add(1, sdiv(sub(#{size_var_name}, 1), 32))))
    return_value$ := add(return_value$, #{size_var_name})
    """
  end

  # BytesN
  def encode(
        %Type{encoded_type: encoded_type, size: byte_size},
        _i_var_name,
        _size_var_name,
        where_to_store_head_var_name,
        _where_to_store_head_init_var_name
      )
      when encoded_type > 69 and encoded_type < 102 do
    offset = 8 * (32 - byte_size)

    """
    #{Utils.generate_type_check("return_value$", encoded_type, "Wrong type for return value, expected BytesN", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)

    mstore(#{where_to_store_head_var_name}, shl(#{offset}, shr(#{offset}, mload(return_value$))))
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)

    return_value$ := add(return_value$, #{byte_size})
    """
  end

  def encode(
        type,
        _i_var_name,
        _size_var_name,
        where_to_store_head_var_name,
        _where_to_store_head_init_var_name
      ) do
    shift_func =
      if type.encoded_type > 35 and type.encoded_type < 68 do
        "sar"
      else
        "shr"
      end

    """
    #{Utils.generate_type_check("return_value$", type.encoded_type, "Wrong type for return value", Enum.random(1_000_000..2_000_000))}

    return_value$ := add(return_value$, 1)
    mstore(#{where_to_store_head_var_name}, #{shift_func}(#{8 * (32 - type.size)}, mload(return_value$)))
    return_value$ := add(return_value$, #{type.size})
    #{where_to_store_head_var_name} := add(#{where_to_store_head_var_name}, 32)
    """
  end

  defp type_to_head_size(%Type{size: :dynamic}) do
    32
  end

  defp type_to_head_size(%Type{calldata_size: calldata_size}) do
    calldata_size
  end
end
