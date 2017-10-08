defmodule Swarmer.Actor.ActorSupervisor do
  use Supervisor
  # {:ok, pid} = Supervisor.start_child(ActorSupervisor, [:zombie, 5,5, self()])
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    worker_opts = []

    children = [
      worker(Swarmer.Actor.ActorServer, [], worker_opts)
    ]
    
    supervise(children, [strategy: :simple_one_for_one])
  end
end
