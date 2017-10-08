defmodule Swarmer.Actor.ActorServer do
  use ExActor.GenServer

  alias Swarmer.Tile
  alias Swarmer.Actor.Zombie

  defmodule State do
    defstruct actor: nil,
              actor_fsm: nil 
  end

  @doc """
  Creates a new server, initialising an actor fsm of `type`
  """
  defstart start_link(type, x, y, tile) do
    actor = get_actor(type)

    # Initialises a new actor
    fsm = actor.new() |> actor.init(x, y, tile)

    state = %State{
      actor: actor,
      actor_fsm: fsm
    }

    # Possible no need for the data call, could just use params
    data = actor.data(fsm)

    Tile.register_actor(tile, {self(), actor, data.x, data.y})

    initial_state(state)
  end

  @doc """
  Gets the state of the actor
  """
  defcall get_state, state: %State{actor: actor, actor_fsm: actor_fsm} do
    reply(actor.state(actor_fsm))
  end

  @doc """
  Gets the data of the actor
  """
  defcall get_data, state: %State{actor: actor, actor_fsm: actor_fsm} do
    reply(actor.data(actor_fsm))
  end

  @doc """
  Gets the current type of the actor
  """
  defcall get_type, state: %{actor: actor}, do: reply(actor)
  
  @doc """
  Basic changes the FSM's state.
  """
  for event <- [:move] do
    defcast unquote(event), state: %State{actor: actor, actor_fsm: actor_fsm} = state do
      new_fsm = apply(actor, unquote(event), [actor_fsm])
      new_state(%State{state | actor_fsm: new_fsm})
    end
  end

  # made the same with metaprogramming above
  # defcast move, state: %{actor: actor, actor_fsm: actor_fsm} = state do 
  #   new_state(%State{state | actor_fsm: actor.move(actor_fsm)})
  # end

  defp get_actor(:zombie), do: Zombie
  defp get_actor(type), do: raise ArgumentError, message: "No actor of type #{type} found."
end
