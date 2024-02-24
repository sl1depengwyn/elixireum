defmodule YulFunction do
  @type t :: %__MODULE__{
          typespec: Typespec.t(),
          body: Macro.t()
        }

  defstruct [:typespec, :body]
end
