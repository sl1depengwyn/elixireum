defmodule Elixireum.Function do
  alias Elixireum.Typespec

  @type t :: %__MODULE__{
          name: atom(),
          typespec: Typespec.t(),
          body: Macro.t(),
          args: [Macro.t()],
          private?: boolean()
        }

  @enforce_keys [:name, :body, :args, :private?]
  defstruct [:name, :body, :args, :typespec, :private?]
end
