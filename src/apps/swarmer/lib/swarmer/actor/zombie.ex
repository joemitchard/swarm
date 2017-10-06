defmodule Swarmer.Actor.Zombie do
  alias Swarmer.Actor.Data

  use Fsm,  initial_state: :waiting,
            initial_data: %Data{}


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

  defstate wandering do
    @doc """
    Stops the zombie by setting it's state to waiting
    """
    defevent wait do
      next_state(:waiting)
    end
  end
end
