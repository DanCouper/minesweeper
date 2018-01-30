defmodule Minesweeper.Mixfile do
  use Mix.Project

  def project do
    [app: :minesweeper,
     version: "0.0.1",
     elixir: "~> 1.6.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: []]
  end

  def application do
    [
      mod: {Minesweeper.Application, []},
      applications: [:logger]
    ]
  end
end
