defmodule Elixireum.Yul.Comparison do
  alias Elixireum.Yul.{StdFunction, Utils}

  def equal? do
    %StdFunction{
      yul: """
      function equal$(ptr_a$, ptr_b$) -> return_value$ {
        let offset$ := msize()
        let type_a$ := byte(0, mload(ptr_a$))
        let type_b$ := byte(0, mload(ptr_b$))

        return_value$ := offset$
        mstore8(offset$, 2)

        offset$ := add(offset$, 1)
        switch eq(type_a$, type_b$)
        case 0 {
          mstore8(offset$, 0)
        }
        case 1 {
          ptr_a$ := add(ptr_a$, 1)
          ptr_b$ := add(ptr_b$, 1)

          let size$ := type_to_byte_size$(type_a$)

          let a$ := shr(mul(sub(32, size$), 8), mload(ptr_a$))
          let b$ := shr(mul(sub(32, size$), 8), mload(ptr_b$))

          mstore8(offset$, eq(a$, b$))
        }
      }
      """
    }
  end
end
