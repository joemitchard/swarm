defmodule Swarmer.Supervisor do
  @moduledoc """
  Supervisor for the Swarmer application.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    children = [
      supervisor(Swarmer.TileSupervisor, []),
      supervisor(Swarmer.ViewerSupervisor, []),

      worker(Swarmer.Environment, [])
    ]

    supervise(children, [strategy: :one_for_one])
  end
end
