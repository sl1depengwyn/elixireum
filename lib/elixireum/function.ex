defmodule Elixireum.Function do
  @type t :: %__MODULE__{
          name: atom(),
          typespec: Typespec.t(),
          body: Macro.t(),
          args: [Macro.t()]
        }

  defstruct [:name, :body, :args, :typespec]
  @enforce_keys [:name, :body, :args]
end
