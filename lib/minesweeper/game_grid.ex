defmodule Minesweeper.GameGrid do
  @moduledoc """
  Represent a game grid as a unidirected graph. For example:

  ```
  {0,0} ━ {1,0} ━ {2,0}
    │   ╳   │   ╳   │
  {0,1} ━ {1,1} ━ {2,1}
    │   ╳   │   ╳   │
  {0,2} ━ {1,2} ━ {2,2}
  ```

  Using Digraph to model this entirely removes the bounding/navigation
  problems inherent in the lists of lists approach, at the cost of increased
  complexity, though this can [will] be mitigated by including an API to access,
  query and modify the graph nodes.

  Each vertex id is a tuple representing the {x,y} coordinates.
  Each vertex label holds the state*.

  DEV NOTES:
  1. digraph has a relatively high start-up cost in terms of memory,
     though subsequently, it is very fast.
  2. Digraph uses ETS tables (3 linked tables),
     and **the graph generated is mutable**.
  3. The table generated stays around as long as the process is open. This
     can cause issues, such as unexpected 'wrong' results due to not
     clearing it down.

  * TODO: what properties the state carries are dependent upon
    implementation, this module currently generates a graph structure only,
    with blank labels (`[]` for each vertex). The label should be defined in
    a module, likely as a struct, with a defined `@behaviour`. The module should
    also contain the core defaults: these are part of the core game structure.
  """
  @default_opts [
    width: 10,
    height: 10,
    directions: [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1},{0, -1}, {-1, -1}],
    grid_indexing: 1
  ]

  @doc """
  NOTE side effects
  """
  def generate_unlabelled_graph(options) do
    opts = Keyword.merge(options, @default_opts)
    coordlist = generate_nodes(opts[:width], opts[:height])

    :digraph.new()
    |> add_vertices(coordlist)
    |> add_edges(coordlist, opts[:width], opts[:height], opts[:directions])
  end

  @doc """
  NOTE side effects
  """
  def add_vertices(graph, coordlist) do
    Enum.each(coordlist, fn coord -> :digraph.add_vertex(graph, coord) end)
    # return the mutated graph:
    graph
  end

  @doc """
  NOTE side effects
  """
  def add_edges(graph, coordlist, width, height, directions) do
    coordlist
    |> Enum.each(fn coord ->
       generate_neighbours(coord, width, height, directions)
       |> Enum.each(fn neighbour_coord ->
        :digraph.add_edge(graph, coord, neighbour_coord)
       end)
    end)
    # return the mutated graph:
    graph
  end

  @doc """
  """
  @spec generate_nodes(number, number) :: [{number, number}]
  def generate_nodes(width, height) do
    for x <- range(width), y <- range(height), do: {x, y}
  end

  @spec generate_neighbours({number, number}, number, number, [{number, number}]) :: [{number, number}]
  def generate_neighbours({x,y}, width, height, directions) do
    for {mod_x, mod_y} <- directions,
      Enum.member?(range(width), x + mod_x), Enum.member?(range(height), y + mod_y)  do
        {x + mod_x, y + mod_y}
    end
  end

  defp range(min \\ 1, max) do
    modifier = min - 1
    Range.new(min, max + modifier)
  end
end
