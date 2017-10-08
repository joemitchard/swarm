defmodule Swarmer.Actor.ZombieTests do
  use ExUnit.Case 

  alias Swarmer.Actor.Zombie

  test "initial state is waiting" do
    assert Zombie.new().state == :waiting
  end

  test "data can be initialised in waiting state" do
    # Pass in self() instead of an actual tile process.
    # Providing the PID is the same the test is successful.
    data = Zombie.new() |> Zombie.init(0, 0, self()) |> Zombie.data()
    assert data.x == 0
    assert data.y == 0
    assert data.tile == self()
  end

  test "a process can't be initialised in moving state" do
    z = Zombie.new() |> Zombie.move()
    assert_raise FunctionClauseError, fn -> Zombie.init(z, 0, 0, self()) end
  end

  test "a waiting zombie can be started" do
    z = Zombie.new() |> Zombie.move()
    assert z.state == :wandering
  end

  test "a moving zombie can be stopped" do
    z = Zombie.new() |> Zombie.move() |> Zombie.wait()
    assert z.state == :waiting
  end
end
