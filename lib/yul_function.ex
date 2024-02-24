defmodule YulFunction do
  @type t :: %__MODULE__{
          function_name: atom(),
          typespec: Typespec.t(),
          body: Macro.t(),
          args: list(atom())
        }

  defstruct [:function_name, :typespec, :body, :args]
end
