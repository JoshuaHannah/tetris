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
        HashDict.new
        |> HashDict.put(21, [4,5,6,7])
        |> HashDict.put(0, {:green, :line})
      2 -> #square
        HashDict.new
        |> HashDict.put(22, [5,6])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, {:blue, :square})
      3 -> #rL
        HashDict.new
        |> HashDict.put(23, [5])
        |> HashDict.put(22, [5])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, {:yellow, :rL})
      4 -> #lL
        HashDict.new
        |> HashDict.put(23, [6])
        |> HashDict.put(22, [6])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, {:cyan, :lL})
      5 -> #rF
       HashDict.new
       |> HashDict.put(23, [5])
       |> HashDict.put(22, [5,6])
       |> HashDict.put(21, [6])
       |> HashDict.put(0, {:red, :rF})
      6 -> #lF
        HashDict.new
        |> HashDict.put(23, [6])
        |> HashDict.put(22, [5,6])
        |> HashDict.put(21, [5])
        |> HashDict.put(0, {:white, :lF})
      7 -> #middle
       HashDict.new
       |> HashDict.put(22, [5])
       |> HashDict.put(21, [4,5,6])
       |> HashDict.put(0, {:magenta, :lF})
    end
  end

  def update(pieces) do
    :lists.reverse([new_piece | :lists.reverse(pieces)])
  end
end
