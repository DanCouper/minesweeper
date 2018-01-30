defmodule Minesweeper.GameSupervisor do
  @moduledoc """
  Create and supervise games.
  """

  use DynamicSupervisor
  require Logger

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(id) do
    game_spec = %{
      :id => __MODULE__,
      :start => {Minesweeper.Game, :start_link, [id]},
    }

    DynamicSupervisor.start_child(__MODULE__, game_spec)
  end
end
