defmodule Swarmer.Actor.ZombieTests do
  use ExUnit.Case 

  alias Swarmer.Actor.Zombie

  test "initial state is waiting" do
    assert Zombie.new().state == :waiting
  end

  test "data can be initialised in waiting state" do
    z = Zombie.new() |> Zombie.init(0, 0, self())
    data = Zombie.data(z)
    assert data.x == 0
    assert data.y == 0
    assert data. tile == self()
  end

  test "a waiting zombie can be started" do
    z = Zombie.new() |> Zombie.move()
    assert z.state == :wandering
  end
end
