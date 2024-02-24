defmodule Typespec do
  @type t :: %__MODULE__{
          args: any(),
          return: any()
        }

  defstruct [:function_name, :args, :return]
end
