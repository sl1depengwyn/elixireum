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
      """,
      deps: %{"type_to_byte_size$": Utils.type_to_byte_size()}
    }
  end

  def less? do
    %StdFunction{
      yul: """
      function less$(ptr_a$, ptr_b$) -> return_value$ {
        let offset$ := msize()
        let type_a$ := byte(0, mload(ptr_a$))
        let type_b$ := byte(0, mload(ptr_b$))

        return_value$ := offset$
        mstore8(offset$, 2)
        offset$ := add(offset$, 1)

        let size_a$ := type_to_byte_size$(type_a$)
        let a$ := shr(mul(sub(32, size_a$), 8), mload(ptr_a$))

        let size_b$ := type_to_byte_size$(type_b$)
        let b$ := shr(mul(sub(32, size_b$), 8), mload(ptr_b$))

        if and(gt(type_a$, 35), lt(type_a$, 68)) {
          if and(gt(type_b$, 35), lt(type_b$, 68)) {
            mstore8(offset$, slt(a$, b$))
            leave
          }
          revert(0, 0)
        }

        mstore8(offset$, lt(a$, b$))

      }
      """,
      deps: %{"type_to_byte_size$": Utils.type_to_byte_size()}
    }
  end

  def greater? do
    %StdFunction{
      yul: """
      function greater$(ptr_a$, ptr_b$) -> return_value$ {
        let offset$ := msize()
        let type_a$ := byte(0, mload(ptr_a$))
        let type_b$ := byte(0, mload(ptr_b$))

        return_value$ := offset$
        mstore8(offset$, 2)
        offset$ := add(offset$, 1)

        let size_a$ := type_to_byte_size$(type_a$)
        let a$ := shr(mul(sub(32, size_a$), 8), mload(ptr_a$))

        let size_b$ := type_to_byte_size$(type_b$)
        let b$ := shr(mul(sub(32, size_b$), 8), mload(ptr_b$))

        if and(gt(type_a$, 35), lt(type_a$, 68)) {
          if and(gt(type_b$, 35), lt(type_b$, 68)) {
            mstore8(offset$, sgt(a$, b$))
            leave
          }
          revert(0, 0)
        }

        mstore8(offset$, gt(a$, b$))

      }
      """,
      deps: %{"type_to_byte_size$": Utils.type_to_byte_size()}
    }
  end
end
