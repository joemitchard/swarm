defmodule Swarmer do
  @moduledoc """
  Documentation for Swarmer.
  """

  use Application

  def start(_type, _args) do

    # start application here
    Swarmer.Supervisor.start_link(name: Swarmer.Supervisor)
  end
end
