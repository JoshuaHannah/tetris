defmodule Tetris.Grid.Formatter do

  def format(grid, piece) do
    [{_, colour}] = piece |> Enum.filter(fn {k,v} -> k == 0 end)
    {piece_coords, _} = piece |> Tetris.Grid.split

    piece_coords_formattable = piece_coords
                               |> Enum.map(fn {k,v} -> Enum.map(v, fn x -> {k,x, colour} end) end)
                               |> :lists.flatten

    all_blocks = grid ++ piece_coords_formattable

    20..1
    |> Enum.to_list
    |> Enum.map(fn x -> Enum.filter(all_blocks, fn {k,v,c} -> k == x end) end)
    |> Enum.map(&format_row(&1))
    |> IO.ANSI.format_fragment
  end

  def format_row([]) do
    ["          \r\n"]
  end

  def format_row(row) do
    1..10
    |> Enum.to_list
    |> Enum.map(fn x -> Enum.filter(row, fn {_k,v,_c} -> v == x end) end)
    |> Enum.map(fn x -> if x == [], do: " ", else: Enum.map(x, fn {_k,_v,c} -> [c, "#"] end) end)
    |> :lists.append("\r\n")
  end
end
