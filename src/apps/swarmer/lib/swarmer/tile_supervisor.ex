defmodule Swarmer.TileSupervisor do
  @moduledoc """
  
  """
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    worker_opts = []

    children = [
      worker(Swarmer.Tile, [], worker_opts)
    ]

    opts = [
      strategy: :simple_one_for_one
    ]
    
    supervise(children, opts)
  end
end