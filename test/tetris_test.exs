defmodule TetrisTest do
  use ExUnit.Case

  test "every piece has a 0 key" do
    l = 1..20
    |> Enum.to_list
    |> Enum.map(fn _x -> Tetris.Pieces.new_piece end)
    |> Enum.map(fn x -> HashDict.get(x, 0) end)
    |> Enum.map(fn x -> x != nil end)
    |> Enum.all?

    assert l = true
  end
end
