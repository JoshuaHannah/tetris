defmodule Tetris.Pieces do

  def new() do
    @doc ~S"""
    Generates a new list of five pieces.
    """
    Enum.to_list(1..5)
    |> Enum.into([], fn x -> new_piece() end)
  end

  def new_piece(num) do
    @doc ~S"""
    Uses Erlang's random module to generate a number between 1 and 7, which corresponds to a piece.
    Exploit the unused position 0 to correspond to the colour of the piece.
    """
    num = :random.uniform(7)
    case num do
      1 -> #line
        HashDict.new
        |> HashDict.put(21, [4,5,6,7])
        |> HashDict.put(0, :green)
      2 -> #square
        HashDict.new
        |> HashDict.put(22, [5,6])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, :blue)
      3 -> #rL
        HashDict.new
        |> HashDict.put(23, [5])
        |> HashDict.put(22, [5])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, :yellow)
      4 -> #lL
        HashDict.new
        |> HashDict.put(23, [6])
        |> HashDict.put(22, [6])
        |> HashDict.put(21, [5,6])
        |> HashDict.put(0, :cyan)
      5 -> #rF
       HashDict.new
       |> HashDict.put(23, [5])
       |> HashDict.put(22, [5,6])
       |> HashDict.put(21, [6])
       |> HashDict.put(0, :red)
      6 -> #lF
        HashDict.new
        |> HashDict.put(23, [6])
        |> HashDict.put(22, [5,6])
        |> HashDict.put(21, [5])
        |> HashDict.put(0, :white)
      7 -> #middle
       HashDict.new
       |> HashDict.put(22, [5])
       |> HashDict.put(21, [4,5,6])
       |> HashDict.put(0, :magenta)
    end
  end
end
