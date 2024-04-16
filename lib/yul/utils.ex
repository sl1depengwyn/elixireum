defmodule Elixireum.Yul.Utils do
  alias Elixireum.Yul.StdFunction

  def load_integer do
    %StdFunction{
      yul: """
        function load_integer$(ptr) -> return_value$, size$ {
          size$ := byte(0, mload(ptr))
          let value := mload(add(ptr, 1))
          switch size$
            #{for i <- 36..67 do
        """
        case #{i} {
          return_value$ := take_#{i - 35}_bytes$(value)
        }
        """
      end}
            default {
              // TypeError
              revert(0, 0)
            }
        }
      """,
      deps:
        MapSet.new(
          for i <- 1..32 do
            fn -> apply(__MODULE__, String.to_atom("take_#{i}_bytes"), []) end
          end
        )
    }
  end

  # to store in opposite order !!
  # components_types = [103,103,67] # [[1],[1],[1]]
  # sizes = [3,1]

  def copy_static_array_from_calldata() do
    %StdFunction{
      yul: """
      function copy_static_array_from_calldata$(array_items_count, components_types, sizes, memory_offset, calldata_offset) ->
         new_memory_offset, new_calldata_offset {
          mstore8(memory_offset, 103)
          mstore(add(memory_offset, 1), array_items_count)
          memory_offset := add(memory_offset, 33)
        for { let i := 0 } lt(i, array_items_count) { i := add(i, 1) } {
          memory_offset, calldata_offset := select_and_call$(components_types, sizes, memory_offset, calldata_offset)
        }
        new_memory_offset := memory_offset
        new_calldata_offset := calldata_offset
      }
      """
    }
  end

  def copy_dynamic_array_from_calldata do
    %StdFunction{
      yul: """
      function copy_dynamic_array_from_calldata$(components_types, sizes, memory_offset, calldata_offset) ->
         new_memory_offset, new_calldata_offset {
          calldata_offset := add(calldata_offset, calldataload(calldata_offset))
          let array_items_count := calldataload(calldata_offset)
          calldata_offset := add(calldata_offset, 32)
          mstore8(memory_offset, 104)
          mstore(add(memory_offset, 1), array_items_count)
          memory_offset := add(memory_offset, 33)
        for { let i := 0 } lt(i, array_items_count) { i := add(i, 1) } {
          memory_offset, calldata_offset := select_and_call$(components_types, sizes, memory_offset, calldata_offset)
        }
        new_memory_offset := memory_offset
        new_calldata_offset := calldata_offset
      }
      """
    }
  end

  def copier_selector do
    %StdFunction{
      yul: """
      function select_and_call$(types, mb_sizes, memory_offset, calldata_offset) -> new_memory_offset, new_calldata_offset {
        let types_size_ptr := add(types, 1)
        let current_types_size := mload(types_size_ptr)
        let types_array_start_ptr := add(types, 33)
        let current_type := mload(add(types_array_start_ptr, mul(33, sub(current_types_size, 1))))
        mstore(types_size_ptr, sub(current_types_size, 1))

        switch current_type
          case 103 {
            let sizes_size_ptr := add(mb_sizes, 1)
            let current_sizes_size := mload(sizes_size_ptr)
            let sizes_array_start_ptr := add(mb_sizes, 33)
            let current_size := mload(add(sizes_array_start_ptr, mul(33, sub(current_sizes_size, 1))))
            mstore(sizes_size_ptr, sub(current_types_size, 1))

            new_memory_offset, new_calldata_offset := copy_static_array_from_calldata$(current_size, types, mb_sizes, memory_offset, calldata_offset)
          }
          case 104 { // dynamic array
            new_memory_offset, new_calldata_offset := copy_dynamic_array_from_calldata$(types, mb_sizes, memory_offset, calldata_offset)
          }
          default {
            new_memory_offset, new_calldata_offset := copy_word_from_calldata$(memory_offset, calldata_offset, current_type)
          }
      }
      """
    }
  end

  # def extract_int_and_move_pointer do
  #   %StdFunction{
  #     yul: """
  #     function extract_int_and_move_pointer$(array_ptr) {

  #     }
  #     """
  #   }
  # end

  def copy_word_from_calldata do
    %StdFunction{
      yul: """
      function copy_word_from_calldata$(memory_offset, calldata_offset, type) -> new_memory_offset, new_calldata_offset {
        mstore8(memory_offset, type)
        calldatacopy(add(memory_offset, 1), calldata_offset, 32)
        new_memory_offset := add(memory_offset, 33)
        new_calldata_offset := add(calldata_offset, 32)
      }
      """
    }
  end

  # TODO implement via mult and for
  for i <- 1..32 do
    def unquote(:"take_#{i}_bytes")() do
      %StdFunction{
        yul: """
        function take_#{unquote(i)}_bytes$(value) -> return_value$ {
          return_value$ := and(value, 0x#{String.duplicate("FF", unquote(i))})
        }
        """
      }
    end
  end
end
