defmodule Swarmer.ViewerTest do
  use ExUnit.Case

  alias Swarmer.Viewer
  
  setup() do
    {:ok, viewer} = Viewer.start_link([])
    {:ok, %{viewer: viewer}}
  end
end
