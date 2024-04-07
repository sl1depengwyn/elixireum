defmodule Elixireum.Yul.Arithmetic do
  alias Elixireum.Yul.{StdFunction, Utils}

  def add do
    %StdFunction{
      deps: MapSet.new([&Utils.load_integer/0]),
      yul: """
      function add$(a, b) -> return_value$ {
        let a$, a_size$ := load_integer$(a)
        let b$, b_size$ := load_integer$(b)
        b$ := add(a$, b$)
        let c := a_size$
        if gt(b_size$, a_size$) {
          c := b_size$
        }
        let offset$ := msize()
        mstore8(offset$, c)
        mstore(add(offset$, 1), b$)
        return_value$ := offset$
      }
      """
    }
  end
end
