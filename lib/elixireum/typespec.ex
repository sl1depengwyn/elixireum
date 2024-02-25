defmodule Elixireum.Typespec do
  @type t :: %__MODULE__{
          args: any(),
          return: any()
        }

  defstruct [:args, :return]
end
