defmodule Tetris.Pieces do

  def new() do
    Enum.to_list(1..5)
    |> Enum.into([], fn x -> new_piece() end)
  end

  def new_piece(num) do
    num = :randon.uniform(7)
    case num do
      1 -> :line
      2 -> :square
      3 -> :rL
      4 -> :lL
      5 -> :rF
      6 -> :lF
      7 -> :middle
    end
  end
end
