defmodule Elixireum.Yul.Arithmetic do
  alias Elixireum.Yul.{StdFunction, Utils}

  def add do
    %StdFunction{
      deps: %{
        "load_var$": Utils.load_var(),
        "type_to_byte_size$": Utils.type_to_byte_size()
      },
      yul: """
      function add$(_a$, _b$) -> return_value$ {
        let a$, a_type$ := load_var$(_a$)
        let b$, b_type$ := load_var$(_b$)
        b$ := add(a$, b$)
        let max_type$ := a_type$
        if gt(b_type$, a_type$) {
          max_type$ := b_type$
        }
        let offset$ := msize()
        mstore8(offset$, max_type$)
        mstore(add(offset$, 1), shl(mul(8, sub(32, type_to_byte_size$(max_type$))), b$))
        return_value$ := offset$
      }
      """
    }
  end

  def sub do
    %StdFunction{
      deps: %{
        "load_var$": Utils.load_var(),
        "type_to_byte_size$": Utils.type_to_byte_size()
      },
      yul: """
      function sub$(a, b) -> return_value$ {
        let a$, a_type$ := load_var$(a)
        let b$, b_type$ := load_var$(b)
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
