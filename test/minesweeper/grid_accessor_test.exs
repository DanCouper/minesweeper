defmodule Minesweeper.GridAccessorTest do
  use ExUnit.Case

  alias Minesweeper.GridAccessor

  test "should return a list containing 8 elements representing adjacent list items" do
    input =  [[1, 1, 1, 3], [2, 2, 3, 1], [3, 3, 3, 1], [2, 2, 3, 1]]
    output = [1,1,3,3,3,3,2,1]

    assert GridAccessor.look_around(input, 1, 1) == output
  end

  test "should return the value at the specified position" do
    input =  [[1, 1, 1, 3], [2, 2, 3, 1], [3, 3, 3, 1], [2, 2, 3, 1]]

    assert GridAccessor.access(input, 3, 2) == 3
    assert GridAccessor.access(input, 0, 1) == 1
  end
end
