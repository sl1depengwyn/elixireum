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
        Map.new(
          for i <- 1..32 do
            {
              :"take_#{i}_bytes$",
              apply(__MODULE__, String.to_atom("take_#{i}_bytes"), [])
            }
          end
        )
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
