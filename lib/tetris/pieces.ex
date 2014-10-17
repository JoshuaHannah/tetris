defmodule Tetris.Pieces do

  @doc ~S"""
  Generates a new list of five pieces.
  """
  def new() do
    Enum.to_list(1..5)
    |> Enum.into([], fn _x -> new_piece() end)
  end


  @doc ~S"""
  Uses Erlang's random module to generate a number between 1 and 7, which corresponds to a piece.
  Exploit the unused position 0 to correspond to the colour of the piece.
  """
  def new_piece() do
    num = :random.uniform(7)
    case num do
      1 -> #line
        [{21, [4,5,6,7]}, {0, :green}, {-1, :line}, {-2, 0}]
      2 -> #square
        [{22, [5,6]}, {21, [5,6]}, {0, :blue}, {-1, :square}, {-2, 0}]
      3 -> #rL
        [{23, [5]}, {22, [5]}, {21, [5,6]}, {0, :yellow}, {-1, :rL}, {-2, 0}]
      4 -> #lL
        [{23, [6]}, {22, [6]}, {21, [5,6]}, {0, :cyan}, {-1, :lL}, {-2, 0}]
      5 -> #rF
        [{23, [5]}, {22, [5,6]}, {21, [6]}, {0, :red}, {-1, :rF}, {-2, 0}]
      6 -> #lF
        [{23, [6]}, {22, [5,6]}, {21, [5]}, {0, :white}, {-1, :lF}, {-2, 0}]
      7 -> #middle
        [{22, [5]}, {21, [4,5,6]}, {0, :magenta}, {-1, :middle}, {-2, 0}]
    end
  end

  def update(pieces) do
    :lists.reverse([new_piece | :lists.reverse(pieces)])
  end
end
