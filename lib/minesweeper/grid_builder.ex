defmodule Minesweeper.GridBuilder do
  alias Minesweeper.GridAccessor
  @moduledoc """
  Functions facilitating the building a list of lists of size (rows × columns),
  representing the game grid.
  """

  @default_rows  10
  @default_cols 10
  @default_active 30
  @default_active_token :active

  @doc """
  The list is initially constructed as a flat list , with the *n* active
  cells as `1`, and inactive as `0`. This is shuffled, partitioned into
  rows, solved, then a 1-cell buffer is added around the edge of the grid.
  """
  @spec construct(number, number, number, atom) :: [maybe_improper_list(number, atom), ...]
  def construct(rows \\ @default_rows,
                cols \\ @default_cols,
                active \\ @default_active,
                active_token \\ @default_active_token,
                seed \\ :random.seed()) do
    List.duplicate(1, active)
    |> Enum.concat(List.duplicate(0, (rows * cols) - active))
    |> Enum.shuffle
    |> Enum.chunk(cols)
    |> solve(active_token)
    |> buffer
  end

  @doc """
  Iterates a grid with values of either `1` (active) or `0` (inactive).
  If active, replaces value with an `:active` token.
  If inactive, counts how many adjacent "grid cells" have a value, and sums those.

      iex > GridBuilder.solve([[1,0,1],[1,0,0],[0,1,0]])
      [[:active,3,:active],[:active,4,2],[2,:active,1]]
  """
  @spec solve([[number, ...], ...], atom) :: [maybe_improper_list(number, atom), ...]
  def solve(grid, token) do
    buffered_grid = buffer(grid)
    # NOTE nested comprehension to generate list of lists.
    for {row, i} <- Enum.with_index(grid) do
      for {col, j} <- Enum.with_index(row) do
        case col do
          1 -> token
          _ -> buffered_grid |> GridAccessor.look_around(i + 1, j + 1) |> Enum.sum
        end
      end
    end
  end

  @doc """
  Inserts and empty row of `0`'s at the start & end of a grid,
  then iterates through all the rows and adds a `0` at the start & end of each.

  Having a bufferzone simplifies lookup of values, eliminating
  out-of-bounds errors.

      iex > GridBuilder.buffer([[1,2],[3,4]])
      [[0,0,0,0],[0,1,2,0],[0,3,4,0],[0,0,0,0]]
  """
  @spec buffer([maybe_improper_list(number, atom), ...]) :: [maybe_improper_list(number, atom), ...]
  def buffer(grid) do
    empty_row = List.duplicate(0, length(Enum.at(grid, 0)))

    grid
    |> List.insert_at(0, empty_row)
    |> List.insert_at(-1, empty_row)
    |> Enum.map(fn row -> List.flatten([0, row, 0]) end)
  end
end
