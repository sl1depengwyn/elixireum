defmodule Test do
  def hello do
    unquote (quote do
      1 + 1
    end)
  end
end
