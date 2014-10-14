defmodule Tetris.Grid.Formatter do

  def format(grid, pieces) do
  20..1
  |> Enum.to_list
  |> Enum.map(fn x -> {HashDict.get(grid, x), HashDict.get(pieces, x), HashDict.get(pieces, 0)} end)
  |> Enum.map(to_rows)
  |> IO.format_fragment
  end

  def to_rows([]) do
    "\r\n"
  end

  def to_rows([{a,b,{c,d}}|t]) do
    1..10
    |> Enum.to_list
    |> Enum.map(fn x ->
       if Enum.member?(a,x) do
          "#"
      else
        if Enum.member?(b,x) do
          [c, "#"]
      else
        " "
    end
  end
end
