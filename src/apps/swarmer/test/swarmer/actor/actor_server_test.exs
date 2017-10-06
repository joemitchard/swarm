defmodule Swarmer.Actor.ActorServerTests do
  use ExUnit.Case 

  alias Swarmer.Actor.ActorServer

  test "start_link/1 initialises an actor of the correct type" do
    {:ok, pid} = ActorServer.start_link(:zombie, 0, 0, self())
    assert :waiting == ActorServer.get_state(pid)
    assert Swarmer.Actor.Zombie == ActorServer.get_type(pid)
  end

  test "start_link/1 initialises with the correct data" do
    {:ok, pid} = ActorServer.start_link(:zombie, 5, 5, self())
    data = ActorServer.get_data(pid)
    assert data.x == 5
    assert data.y == 5
    assert data.tile == self()
  end

  test "move sets the actor to it's :wandering state" do
    {:ok, pid} = ActorServer.start_link(:zombie, 0, 0, self())
    ActorServer.move(pid)
    assert :wandering == ActorServer.get_state(pid)
  end
end
