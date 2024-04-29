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
        let max_type := a_type$
        if gt(b_type$, a_type$) {
          max_type := b_type$
        }
        let offset$ := msize()
        mstore8(offset$, max_type)
        mstore(add(offset$, 1), shl(mul(8, sub(32, type_to_byte_size$(max_type))), b$))
        return_value$ := offset$
      }
      """
    }
  end

  def sub do
    %StdFunction{
      deps: %{"load_integer$": Utils.load_integer()},
      yul: """
      function sub$(a, b) -> return_value$ {
        let a$, a_type$ := load_integer$(a)
        let b$, b_type$ := load_integer$(b)
        b$ := sub(a$, b$)
        let max_type := a_type$
        if gt(b_type$, a_type$) {
          max_type := b_type$
        }
        let offset$ := msize()
        mstore8(offset$, max_type)
        mstore(add(offset$, 1), shl(mul(8, sub(32, type_to_byte_size$(max_type))), b$))
        return_value$ := offset$
      }
      """
    }
  end
end
