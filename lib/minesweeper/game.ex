defmodule Minesweeper.Game do
  use GenServer
  require Logger

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end



  @impl true
  def init(id) do
    Logger.info "Initialised game under ID #{id}"

    {:ok, []}
  end

  # Helper to register/access a game via the order id
  defp via_tuple(id) do
    {:via, Registry, {Minesweeper.GameRegistry, id}}
  end
end
