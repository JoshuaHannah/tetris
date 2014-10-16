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
        [{21, [4,5,6,7}, {-1, :green}, {0, :line}, {-2, 0}]
      2 -> #square
        [{22, [5,6]}, {21, [5,6]}, {-1, :blue}, {0, :square}, {-2, 0}]
      3 -> #rL
        [{23, [5]}, {22, [5]}, {21, [5,6]}, {-1, :yellow}, {0, :rL}, {-2, 0}]
      4 -> #lL
        [{23, [6]}, {22, [6]}, {21, [5,6]}, {-1, :cyan}, {0, :rL}, {-2, 0}]
      5 -> #rF
        [{23, [5]}, {22, [5,6]}, {21, [6]}, {-1, :red}, {0, :rF}, {-2, 0}]
      6 -> #lF
        [{23, [6]}, {22, [5,6]}, {21, [5]}, {-1, :white}, {0, :lF}, {-2, 0}]
      7 -> #middle
        [{22, [5]}, {21, [4,5,6]}, {-1, :magenta}, {0, :lF}, {-2, 0}]
    end
  end

  def update(pieces) do
    :lists.reverse([new_piece | :lists.reverse(pieces)])
  end
end
