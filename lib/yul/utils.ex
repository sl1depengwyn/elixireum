defmodule Elixireum.Yul.Utils do
  alias Elixireum.Yul.StdFunction

  def load_integer do
    %StdFunction{
      yul: """
        function load_integer$(ptr) -> return_value, type {
          type := byte(0, mload(ptr))
          let value := mload(add(ptr, 1))
          let size := type_to_byte_size$(type)
          return_value$ := shl(mul(sub(32, size), 8), value)
        }
      """,
      deps: Map.new([&address_to_byte_size/0, &type_to_byte_size/0])
    }
  end

  def address_to_byte_size() do
    %StdFunction{
      yul: """
      function address_to_byte_size$(ptr) -> size {
        let type := byte(0, mload(ptr))
        size := type_to_byte_size$(type)
      }
      """
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
end
