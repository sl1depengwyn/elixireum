defmodule Typespec do
  @type t :: %__MODULE__{
    function_name: atom(),
    args: any(),
    return: any()
  }

  defstruct [:function_name, :args, :return]
end
