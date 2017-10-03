defmodule Swarmer.Tile do
  @moduledoc """
  Maintains the state of a tile within part of a grid.
  """
  use GenServer

  defmodule State do
    defstruct coords: nil,
              viewer: nil,
              neighbours: nil,
              zombies: nil,
              humans: nil,
              items: nil
  end

  defmodule Coord do
    defstruct x_origin: nil,
              x_limit: nil,
              y_origin: nil,
              y_limit: nil,
              size: nil
  end

  ### API
  def start_link(name, opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  API endpoint to request current coordinates of the `tile`.
  """
  def get_coordinates(pid) do
    GenServer.call(pid, :get_coordinates)
  end

  @doc """
  API endpoint to request the pid of the `tile`'s current viewer.
  """
  def get_viewer(pid) do
    GenServer.call(pid, :get_viewer)
  end

  @doc """
  API endpoint to request current neighbouring viewers.
  """
  def get_neighbours(pid) do
    GenServer.call(pid, :get_neighbours)
  end

  @doc """
  API endpoint to set the viewers of neighbouring tiles.
  """
  def set_neighbours(pid, neighbour_pids) do
    GenServer.cast(pid, {:set_neighbours, neighbour_pids})
  end

  ### Server
  def init(opts \\ []) do
    state = %State{
      zombies: %{},
      humans: %{},
      items: %{},
      neighbours: []
    }

    init(opts, state)
  end

  def init([{:x, x}, {:y, y}, {:size, size} | rest], state) do
    coords = build_coords(x, y, size)
    init(rest, %{state | coords: coords})
  end

  def init([{:viewer, viewer} | rest], state) do
    init(rest, %{state | viewer: viewer})
  end

  def init([_ | rest], state),  do: init(rest, state)
  def init([], state),          do: {:ok, state}

  @doc """
  Handles syncronous server calls for the `tile`.
  """
  def handle_call(:get_coordinates, _from, %State{coords: coords} = state) do
    {:reply, coords, state}
  end

  def handle_call(:get_viewer, _from, %State{viewer: viewer} = state) do
    {:reply, viewer, state}
  end

  def handle_call(:get_neighbours, _from, %State{neighbours: neighbours} = state) do
    {:reply, neighbours, state}
  end

  @doc """
  Handles asyncronous server calls for the `tile`.
  """
  def handle_cast({:set_neighbours, neighbour_pids}, state) do
    {:noreply, %State{state | neighbours: neighbour_pids}}
  end


  ### Private
  defp build_coords(x, y, size) do
    %Coord{
      x_origin: x, 
      x_limit: calculate_limit(x, size),
      y_origin: y,
      y_limit: calculate_limit(y, size),
      size: size
    }
  end

  defp calculate_limit(0, size), do: size - 1
  defp calculate_limit(n, size), do: n + size - 1

end
