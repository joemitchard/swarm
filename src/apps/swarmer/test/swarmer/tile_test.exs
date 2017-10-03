defmodule Swarmer.TileTest do
  use ExUnit.Case 

  alias Swarmer.Viewer
  alias Swarmer.Tile
  alias Swarmer.Tile.Coord

  @tile_size 10
  @valid_tile([x: 0, y: 0, size: @tile_size])

  setup do
    {:ok, viewer} = Viewer.start_link()
    {:ok, tile} = Tile.start_link(:t1, [viewer: viewer] ++ @valid_tile)
    {:ok, %{tile: tile, viewer: viewer}}
  end

  test "tile spawns with the correct coordinates", %{tile: tile} do
    coords = Tile.get_coordinates(tile)

    assert %Coord{x_limit: 9, x_origin: 0, y_limit: 9, y_origin: 0, size: @tile_size} == coords
  end

  test "assigns viewer correctly", %{tile: tile, viewer: viewer} do
    tile_viewer = Tile.get_viewer(tile)
    assert ^viewer = tile_viewer
  end

  test "sets and gets the neighbouring viewers correctly", %{tile: tile} do
    {:ok, v1} = Viewer.start_link()
    {:ok, v2} = Viewer.start_link()
    {:ok, v3} = Viewer.start_link()

    neighbours = [v1, v2, v3]

    Tile.set_neighbours(tile, neighbours)

    assert ^neighbours = Tile.get_neighbours(tile)
  end

end
