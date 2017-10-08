defmodule Swarmer.Actor.Data do
  @moduledoc """
  A data struct for the FSM actors.
  This struct will be manipulated by the actors.
  """
  defstruct x: nil,
            y: nil,
            speed: nil,
            tile: nil,
            viewer: nil
end
