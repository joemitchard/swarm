defmodule Swarmer.Environment do
  @moduledoc """
  Maintains the grid and status of the simulation.
  """    
  use GenServer

  alias Swarmer.{Grid, Tile, TileSupervisor, ViewerSupervisor}

  defmodule State do
    defstruct grid: nil,
              rows: nil,
              columns: nil,
              tile_size: nil
  end

  ### API
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Initialises the a grid.
  """
  def create_grid(rows, columns, tile_size) do
    GenServer.call(__MODULE__, {:create_grid, rows, columns, tile_size})
  end

  ### Server
  def init([]) do
    state = %State{
      grid: [],
      rows: [],
      columns: [],
      tile_size: 0
    }
    {:ok, state}
  end

  @doc """
  Handles syncronous calls to the server.
  """
  def handle_call({:create_grid, rows, columns, tile_size}, _from, state) do
    cleanup()

    grid = Grid.create(rows, columns, tile_size)

    # Fire and forget task to process configuring the tiles
    # TODO -> Verify that this is setting correctly
    Task.start(fn -> configure_neighbouring_tiles(grid) end)

    {:reply, :ok, %State{state | grid: grid}}
  end

  ### Privates
  defp cleanup() do
    Supervisor.terminate_child(Swarmer.Supervisor, TileSupervisor)
    Supervisor.restart_child(Swarmer.Supervisor, TileSupervisor)

    Supervisor.terminate_child(Swarmer.Supervisor, ViewerSupervisor)
    Supervisor.restart_child(Swarmer.Supervisor, ViewerSupervisor)
  end

  defp configure_neighbouring_tiles(grid) do
    # For each element in the grid, need to pass all of the viewers of the surrounding tiles 
    # to each tile
    geom_grid = Enum.map(grid, fn (%Grid.GridTile{tile_name: n, viewer: v}) -> 
                                  {v, Tile.get_coordinates(n)} 
                                end)
    tiles = Enum.map(grid, &(&1.tile_name))
    set_neighbouring(tiles, geom_grid)
  end

  # Loop through each GridTile, setting the neighbours for each tile
  defp set_neighbouring([], _geom_grid), do: :ok
  defp set_neighbouring([tile | rest], geom_grid) do
    # Get the coordinates for this tile
    tile_coords = Tile.get_coordinates(tile)
    neighbours = Grid.get_neighbouring_tiles(tile_coords.x_origin, tile_coords.y_origin, geom_grid)
    Tile.set_neighbours(tile, neighbours)
    set_neighbouring(rest, geom_grid)
  end
end
