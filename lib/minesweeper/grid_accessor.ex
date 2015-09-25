defmodule Minesweeper.GridAccessor do

  @doc """
  Given a list of lists representing a grid, and a row and column value, returns
  an 8-element list representing adjacent values, moving clockwise from top:
  [N, NE, E, SE, S, SW, W, NW]

  FIXME What happens if I am out of bounds?
  """
  @spec look_around([maybe_improper_list(number, atom), ...], number, number) :: maybe_improper_list(number, atom)
  def look_around(grid, row, col) do
    for {r, c} <- [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1},{0, -1}, {-1, -1}] do
      access(grid, row + r, col + c)
    end
  end

  @doc """
  Given a list of lists representing a grid, and a row and column value, returns
  the value at that position.

  FIXME What happens if I am out of bounds?
  """
  @spec access([maybe_improper_list(number, atom), ...], number, number) :: number|atom
  def access(grid, row, col) do
    grid |> Enum.at(row) |> Enum.at(col)
  end
end
