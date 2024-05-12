defmodule Elixireum.Yul.Logic do
  alias Elixireum.Yul.{StdFunction, Utils}

  def or_def do
    %StdFunction{
      yul: """
      function or$(ptr_a$, ptr_b$) -> return_value$ {
        let offset$ := msize()

        return_value$ := offset$
        mstore8(offset$, 2)
        offset$ := add(offset$, 1)

        let size_a$ := address_to_byte_size$(ptr_a$)
        let a$ := shr(mul(sub(32, size_a$), 8), mload(ptr_a$))

        let size_b$ := address_to_byte_size$(ptr_a$)
        let b$ := shr(mul(sub(32, size_b$), 8), mload(ptr_b$))

        mstore8(offset$, gt(or(a$, b$), 0))
      }
      """,
      deps: %{"address_to_byte_size$": Utils.address_to_byte_size()}
    }
  end

  def and_def do
    %StdFunction{
      yul: """
      function and$(ptr_a$, ptr_b$) -> return_value$ {
        let offset$ := msize()

        return_value$ := offset$
        mstore8(offset$, 2)
        offset$ := add(offset$, 1)

        let size_a$ := address_to_byte_size$(ptr_a$)
        let a$ := shr(mul(sub(32, size_a$), 8), mload(ptr_a$))

        let size_b$ := address_to_byte_size$(ptr_a$)
        let b$ := shr(mul(sub(32, size_b$), 8), mload(ptr_b$))

        mstore8(offset$, gt(and(a$, b$), 0))
      }
      """,
      deps: %{"address_to_byte_size$": Utils.address_to_byte_size()}
    }
  end

  def not_def do
    %StdFunction{
      yul: """
      function not$(ptr_a$) -> return_value$ {
        let offset$ := msize()

        return_value$ := offset$
        mstore8(offset$, 2)
        offset$ := add(offset$, 1)

        let size_a$ := address_to_byte_size$(ptr_a$)
        let a$ := shr(mul(sub(32, size_a$), 8), mload(ptr_a$))

        mstore8(offset$, iszero(a$))
      }
      """,
      deps: %{"address_to_byte_size$": Utils.address_to_byte_size()}
    }
  end
end
