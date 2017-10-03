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


  ### Server
  def init(_opts, state), do: {:ok, state}
end
