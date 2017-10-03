defmodule Swarmer.EnvironmentTests do
  use ExUnit.Case

  alias Swarmer.{Environment, Tile}

  @grid_depth 3
  @grid_tile_size 10
  
  setup do
    Environment.create_grid(@grid_depth, @grid_depth, @grid_tile_size)
  end

  test "Environment.create_grid/3 creates a 9 tile grid" do
    %{active: tile_count} = Supervisor.count_children(Swarmer.TileSupervisor)
    %{active: viewer_count} = Supervisor.count_children(Swarmer.ViewerSupervisor)

    assert ^tile_count = 9
    assert ^viewer_count = 9
  end

  test "Environment.create_grid/2 names tiles correctly" do
    assert :tileX0Y0
            |> Process.whereis()
            |> Process.alive?()


    assert :tileX2Y2
            |> Process.whereis()
            |> Process.alive?()

    # An out of bounds tile has not been created
    refute is_pid(Process.whereis(:tileX3Y3))
  end

  test "Environment.create_grid/2 creates tiles with the correct coordinates" do
    t1_coords = Tile.get_coordinates(:tileX0Y0)
    
    t1_expected = %Tile.Coord{
      x_origin: 0, 
      x_limit: 9,
      y_origin: 0,
      y_limit: 9,
      size: 10
    }

    assert t1_coords == t1_expected

    t2_coords = Tile.get_coordinates(:tileX2Y2)

    t2_expected = %Tile.Coord{
      x_origin: 20,
      x_limit: 29,
      y_origin: 20,
      y_limit: 29,
      size: 10
    }

    assert t2_coords == t2_expected
  end
end
