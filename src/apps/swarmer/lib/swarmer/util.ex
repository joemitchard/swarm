defmodule Swarmer.Util do
  @doc """
  Gets a tile name from an `x` and `y` origin.
  """
  def get_tile_name(x, y) do
    "tileX#{Integer.to_charlist(x)}Y#{Integer.to_charlist(y)}"
    |> String.to_charlist()
    |> List.to_atom()
  end

  @doc """
  Gets a tile from an `x` and `y` position based on `tile_size`.
  """
  def get_tile_from_position(x, y, tile_size) do
    get_tile_name(div(x, tile_size), div(y, tile_size))
  end
end
