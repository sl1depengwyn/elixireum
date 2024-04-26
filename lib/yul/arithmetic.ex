defmodule Elixireum.Yul.Arithmetic do
  alias Elixireum.Yul.{StdFunction, Utils}

  def add do
    %StdFunction{
      deps: %{"load_integer$": Utils.load_integer()},
      yul: """
      function add$(a, b) -> return_value$ {
        let a$, a_type$ := load_integer$(a)
        let b$, b_type$ := load_integer$(b)
        b$ := add(a$, b$)
        let c := a_type$
        if gt(b_type$, a_type$) {
          c := b_type$
        }
        let offset$ := msize()
        mstore8(offset$, c)
        mstore(add(offset$, 1), shl(mul(8, sub(32, type_to_byte_size$(c))), b$))
        return_value$ := offset$
      }
      """
    }
  end
end
