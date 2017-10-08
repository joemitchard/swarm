defmodule Swarmer.Viewer do
  @moduledoc """
  Maintains a map of tile => entitys of the surrounding tiles.
  TODO -> Turn this into an agent
  """
  use GenServer

  defmodule State do
    defstruct tiles: nil, # remove?
              zombies: nil,
              humans: nil 
  end

  ### API
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def update_zombies(pid, tile, zombies) do
    GenServer.cast(pid, {:update_zombies, tile, zombies})
  end

  ### Server
  def init(_opts, state), do: {:ok, state}

  def handle_cast({:update_zombies, tile, new_zombies}, %{zombies: zombies} = state) do
    zombies = Map.put(zombies, tile, new_zombies)
    {:noreply, %State{state | zombies: zombies}}
  end
end
