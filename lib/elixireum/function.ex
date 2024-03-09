defmodule Elixireum.Function do
  @type t :: %__MODULE__{
          name: atom(),
          typespec: Typespec.t(),
          body: Macro.t(),
          args: [Macro.t()],
          private?: boolean()
        }

  defstruct [:name, :body, :args, :typespec, :private?]
  @enforce_keys [:name, :body, :args, :private?]
end
