defmodule Swarmer.Grid do
  @moduledoc """
  Builds a grid by spawning tiles and viewers.
  """
  alias Swarmer.{TileSupervisor, ViewerSupervisor}

  defmodule GridTile do
    defstruct tile_name: nil,
              viewer: nil
  end

  @doc """
  Creates a `rows`x`columns` grid, each tile being of `tile_size`.
  """
  def create(rows, columns, tile_size) do
    make_grid(0, rows, columns, tile_size, [])
  end

  @doc """
  Tests if two tiles are neigbouring.

  `x` -> x orign for the tile
  `y` -> y origin for the tile
  `x_comp` -> x origin for tile to compare
  `y_comp` -> y origin for tile to compare
  `size` -> size of the tile
  """
  def is_neighbour?(x, y, x_comp, y_comp, size) do
    (x_comp == (x + size)) or (x_comp == x) or (x_comp == (x - size))
    and
    (y_comp == (y + size)) or (y_comp == y) or (y_comp == (y - size))
  end

  @doc """
  Returns all tiles that neighbour a tile beginning at `x` and `y`.
  """
  def get_neighbouring_tiles(x, y, geom_grid), do: get_neighbouring(x, y, geom_grid, [])

  # Create a grid, spawning tiles and viewers
  defp make_grid(row_counter, rows, _cols, _ts, grid_acc) when row_counter > rows - 1 do 
    grid_acc
  end
  defp make_grid(row_counter, rows, cols, ts, grid_acc) do
    new_grid = grid_acc ++ make_row(row_counter, cols, 0, ts)
    make_grid(row_counter + 1, rows, cols, ts, new_grid)
  end

  defp make_row(row_counter, columns, column_counter, tile_size) do
    make_row(row_counter, columns, column_counter, tile_size, [])
  end

  # Spawns a tile, setting it's position
  defp make_row(_r_counter, cols, c_counter, _tile_size, row_acc) when c_counter > cols - 1 do
    row_acc
  end
  defp make_row(r_counter, cols, c_counter, tile_size, row_acc) do
    name = make_tile_name(r_counter, c_counter)
    {:ok, viewer} = Supervisor.start_child(ViewerSupervisor, [])
    
    tile_opts = [
      viewer: viewer,
      x: c_counter * tile_size,
      y: r_counter * tile_size,
      size: tile_size
    ]
    
    {:ok, _tile} = Supervisor.start_child(TileSupervisor, [name, tile_opts])

    grid_tile = %GridTile{tile_name: name, viewer: viewer}

    make_row(r_counter, cols, c_counter + 1, tile_size, row_acc ++ [grid_tile])
  end

  # Makes an atom for a tile name
  defp make_tile_name(row_counter, col_counter) do
    "tileX#{Integer.to_charlist(row_counter)}Y#{Integer.to_charlist(col_counter)}"
    |> String.to_charlist()
    |> List.to_atom()
  end

  # Finds neighbouring tiles
  defp get_neighbouring(_x, _y, [], neighbours), do: neighbours
  defp get_neighbouring(x, y, [item|rest], neighbours) do
    {viewer, comp} = item
    case is_neighbour?(x, y, comp.x_origin, comp.y_origin, comp.size) do
      true ->
        get_neighbouring(x, y, rest, neighbours ++ [viewer])
      false ->
        get_neighbouring(x, y, rest, neighbours)
    end
  end
end
