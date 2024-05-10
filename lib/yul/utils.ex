defmodule Elixireum.Yul.Utils do
  alias Elixireum.Yul.StdFunction

  def load_integer do
    %StdFunction{
      yul: """
        function load_integer$(ptr) -> return_value, type {
          type := byte(0, mload(ptr))
          let value := mload(add(ptr, 1))
          let size := type_to_byte_size$(type)
          return_value := shr(mul(sub(32, size), 8), value)
        }
      """,
      deps: %{type_to_byte_size: type_to_byte_size()}
    }
  end

  def address_to_byte_size() do
    %StdFunction{
      yul: """
      function address_to_byte_size$(ptr) -> size {
        let type := byte(0, mload(ptr))
        size := type_to_byte_size$(type)
      }
      """,
      deps: %{type_to_byte_size: type_to_byte_size()}
    }
  end

  def type_to_byte_size() do
    %StdFunction{
      yul: """
      function type_to_byte_size$(type) -> size {
        switch type
        case 1 {size := 32}
        case 2 {size := 1}
        case 3 {size := 32}
        case 68 {size := 20}
        case 102 {size := 32}
        default {
          if lt(type, 36) {
            size := sub(type, 3)
            leave
          }
          if lt(type, 68) {
            size := sub(type, 35)
            leave
          }
          if lt(type, 102) {
            size := sub(type, 69)
            leave
          }
        }
      }
      """
    }
  end

  # todo replace bytes/string copy with mcopy
  def copy_var() do
    %StdFunction{
      yul: """
      function copy_from_pointer_to$(ptr_from, ptr_to) -> ptr_from_end, ptr_to_end {
        let type := byte(0, mload(ptr_from))
        mstore8(ptr_to, type)
        ptr_to := add(ptr_to, 1)
        ptr_from := add(ptr_from, 1)
        let size := 0

        switch type
        case 1 {
          size := mload(ptr_from)
          mstore(ptr_to, size)
          ptr_to := add(ptr_to, 32)
          ptr_from := add(ptr_from, 32)

          let iterations_count := add(1, div(sub(size, 1), 32))

          for {let i := 0} lt(i, iterations_count) {i := add(i, 1)} {
            mstore(ptr_to, mload(ptr_from))
            ptr_from := add(ptr_from, 32)
            ptr_to := add(ptr_to, 32)
          }
          let mod_ := mod(size, 32)
          if gt(mod_, 0) {
            let dif := sub(32, mod_)
            ptr_to_end := sub(ptr_to, dif)
            ptr_from_end := sub(ptr_from, dif)
          }
          leave
        }

        case 102 {
          size := mload(ptr_from)
          mstore(ptr_to, size)
          ptr_to := add(ptr_to, 32)
          ptr_from := add(ptr_from, 32)

          let iterations_count := add(1, div(sub(size, 1), 32))

          for {let i := 0} lt(i, iterations_count) {i := add(i, 1)} {
            mstore(ptr_to, mload(ptr_from))
            ptr_from := add(ptr_from, 32)
            ptr_to := add(ptr_to, 32)
          }
          let mod_ := mod(size, 32)
          ptr_to_end := ptr_to
          ptr_from_end := ptr_from
          if gt(mod_, 0) {
            let dif := sub(32, mod_)
            ptr_to_end := sub(ptr_to, dif)
            ptr_from_end := sub(ptr_from, dif)
          }
          leave
        }

        case 2 {
          size := 1
        }

        case 68 {
          size := 20
        }

        case 3 {
          // tuple
          size := mload(ptr_from)
          ptr_from := add(ptr_from, 32)
          mstore(ptr_to, size)
          ptr_to := add(ptr_to, 32)

          for {let i := 0} lt(i, size) {i := add(i, 1)} {
            ptr_from, ptr_to := copy_from_pointer_to$(ptr_from, ptr_to)
          }
          leave
        }

        case 103 {
          // list
          size := mload(ptr_from)
          ptr_from := add(ptr_from, 32)
          mstore(ptr_to, size)
          ptr_to := add(ptr_to, 32)

          for {let i := 0} lt(i, size) {i := add(i, 1)} {
            ptr_from, ptr_to := copy_from_pointer_to$(ptr_from, ptr_to)
          }
          leave
        }


        default {
          if lt(type, 102) {
            size := sub(type, 69)
          }
          if lt(type, 68) {
            size := sub(type, 35)
          }
          if lt(type, 36) {
            size := sub(type, 3)
          }
        }

        mstore(ptr_to, mload(ptr_from))
        ptr_from_end := add(ptr_from, size)
        ptr_to_end := add(ptr_to, size)
      }
      """
    }
  end
end
