defmodule Minesweeper.GameGridTest do
  use ExUnit.Case

  alias Minesweeper.GameGrid
  @default_opts [
    width: 10,
    height: 10,
    directions: [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1},{0, -1}, {-1, -1}],
    grid_indexing: 1
  ]

  test "given a basic width and height, should return a directed graph representing the playing surface" do
    input  = GameGrid.generate_unlabelled_graph(@default_opts)
  end

  test "Low level: should generate a set of (x,y) coordinates representing nodes" do
    input  = GameGrid.generate_nodes(3,3)
    output = [{1, 1}, {1, 2}, {1, 3}, {2, 1}, {2, 2}, {2, 3}, {3, 1}, {3, 2}, {3, 3}]

    assert input == output
  end

  test "Low level: should generate the coordinates of neighbours" do
    input  = GameGrid.generate_neighbours({1,1}, 3, 3, @default_opts[:directions])
    output = [{1,2},{2,1},{2,2}]

    assert Enum.sort(input) == output
  end

  test "Low level: should generate the 8 coordinates representing neighbours of central cell" do
    input  = GameGrid.generate_neighbours({2,2}, 3, 3, @default_opts[:directions])
    output = [{1,1},{1,2},{1,3},{2,1},{2,3},{3,1},{3,2},{3,3}]

    assert Enum.sort(input) == output
  end

  test "Low level: should add vertices to a grid" do
    coordlist = GameGrid.generate_nodes(3,3)
    input  = GameGrid.add_vertices(:digraph.new(), coordlist)

    assert :digraph.no_vertices(input) == 9
  end

  test "Low level: should add edges to a grid" do
    coordlist = GameGrid.generate_nodes(3,3)
    grid      = GameGrid.add_vertices(:digraph.new(), coordlist)
    input     = GameGrid.add_edges(grid, coordlist, 3, 3, @default_opts[:directions])

    assert :digraph.no_edges(input) == 40
  end
end
