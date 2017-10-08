defmodule Swarmer.Actor.Zombie do
  @moduledoc """
  FSM implementation for a `Zombie` actor.
  Initialises state as :waiting with an empty `Swarmer.Actor.Data` struct as data.

  When in the :waiting state, you can pass in initialisation data by triggering the
  `init/3` event.
  """
  alias Swarmer.Actor.Data

  use Fsm,  initial_state: :waiting,
            initial_data: %Data{}

  @doc """
  Initial state for the actor.
  This state stops processing until restarting.

  FSM can be initialised by calling the `init/3` event.
  FSM can be started by calling the `move/0` event.
  """
  defstate waiting do
    @doc """
    Initialises the tile with data
    """
    defevent init(x, y, tile), data: data do
      new_data = %Data{data | x: x, y: y, tile: tile}
      next_state(:waiting, new_data)
    end
    
    @doc """
    Changes the zombies state to wandering
    """
    defevent move do
      next_state(:wandering)
    end
  end

  @doc """
  Wandering state for the actor.
  This is the 'running' state of the FSM, and the actor
  will run through it's behaviours.

  FSM can be stopped by calling the `wait` event.
  """
  defstate wandering do
    @doc """
    Stops the zombie by setting it's state to :waiting
    """
    defevent wait do
      next_state(:waiting)
    end
  end
end
