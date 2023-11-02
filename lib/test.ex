defmodule HaHaHa.Test do
  def hello do
    unquote (quote do
      1 + 1
    end)
  end
end

defmodule Hello do
  alias HaHaHa.Test
end
