defmodule Swarmer.GridTests do
  use ExUnit.Case

  alias Swarmer.Grid

  test "tests is_neighbour? returns true for neighbouring tiles" do
    x = 0
    y = 0
    size = 10

    assert Grid.is_neighbour?(x, y, 0, 10, size)
    assert Grid.is_neighbour?(x, y, 10, 10, size)
    assert Grid.is_neighbour?(x, y, 10, 0, size)
  end

  test "tests is_neighbours? returns false for non neighbouring tiles" do
    x = 0
    y = 0
    size = 10

    refute Grid.is_neighbour?(x, y, 20, 20, size)
    refute Grid.is_neighbour?(x, y, 11, 11, size)
    refute Grid.is_neighbour?(x, y, 11, 21, size)
  end
end
