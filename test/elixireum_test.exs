defmodule ElixireumTest do
  use ExUnit.Case
  doctest Elixireum

  test "greets the world" do
    assert Elixireum.hello() == :world
  end
end
