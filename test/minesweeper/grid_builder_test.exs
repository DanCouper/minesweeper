defmodule Minesweeper.GridBuilderTest do
  use ExUnit.Case

  alias Minesweeper.GridBuilder

  test "should generate an improper list of lists representing a minesweeper board" do
    :random.seed(1)

    input  = GridBuilder.construct(2, 2, 2, :active)
    output = [[0, 0, 0, 0], [0, :active, 2, 0], [0, :active, 2, 0], [0, 0, 0, 0]]

    assert input == output
  end

  test "should solve a grid" do
    input  = [[1,0,1],[1,0,0],[0,1,0]]
    output = [[:active,3,:active],[:active,4,2],[2,:active,1]]

    assert GridBuilder.solve(input, :active) == output
  end

  test "should add a buffer zone around a list of lists" do
    input  = [[1,2],[3,4]]
    output = [[0,0,0,0],[0,1,2,0],[0,3,4,0],[0,0,0,0]]

    assert GridBuilder.buffer(input) == output
  end
end
