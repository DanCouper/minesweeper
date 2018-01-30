defmodule Minesweeper.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Minesweeper.GameSupervisor,
      {Registry, [keys: :unique, name: Minesweeper.GameRegistry]}
    ]

    options = [strategy: :one_for_one, name: Minesweeper.Supervisor]
    Supervisor.start_link(children, options)
  end
end
