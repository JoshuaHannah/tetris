defmodule Tetris.Grid do

  defstruct :name, :points: 0

  def new() do
    HashDict.new
  end

  def keystroke(state, key) do
    @doc ~S"""
    Pattern matches the keystroke to identify what action should be taken
    on the active piece.
    """
    case key do
      :space ->
         drop(state)
      :up ->
        rotate(state)
      _ ->
        move(state, key)
    end
  end

  def move(%Game{grid: grid, pieces: pieces, points: points}, direction) do
    @doc ~S"""
    Moves the active piece the corresponding direction.
    Returns {grid, pieces, points}.
    """
    [fpiece | rpieces] = pieces
    newPiece =
    fpiece
    |> Enum.to_list
    |> :lists.droplast
    case direction do
      :down ->
        downPiece = Enum.map(newPiece, fn {h, b} -> {h -1, b} end)
        cond do
          collides?(grid, downPiece) ->
            {newGrid, newPoints} = onCollision(grid, fpiece)
            {newGrid, Pieces.update(rpieces), points + newPoints}

          true -> {pieceCons(fpiece, grid), Pieces.update(rpieces), points}
        end

      :right ->
        rightPiece = Enum.map(newPiece, fn {h, b} -> {h, Enum.map(b, fn x -> x + 1 end)} end)
        cond do
          badmove?(:right, rightPiece) or collides?(grid, rightPiece) ->
            {grid, pieces, points}

          true ->
            newfpiece =
            rightPiece ++ :lists.last(Enum.to_list(fpiece))
            |> Enum.into(HashDict.new)
            {grid, [newfpiece | rpieces], points}
        end

        :left ->
          leftPiece = Enum.map(newPiece, fn {h, b} -> {h, Enum.map(b, fn x -> x - 1 end)} end)
          cond do
            badmove?(:left, rightPiece) or collides?(grid, leftPiece) ->
              {grid, pieces, points}

            true ->
              newfpiece =
              leftPiece ++ :lists.last(Enum.to_list(fpiece))
              |> Enum.into(HashDict.new)
              {grid, [newfpiece | rpieces], points}
          end
    end
  end

  def collides?(grid, piece) do
    piece |> Enum.any?(fn x -> member?(grid, x) end)
  end

  def badmove?(move, piece) do
    flatPiece = piece |> Enum.map(fn {h, b} -> b end) |> Enum.flatten
    case move do
      :right ->
        flatPiece |> Enum.member?(11)
      :left ->
        flatPiece |> Enum.member?(-1)
    end
  end

  def onCollision(grid, fpiece) do #Disgusting code. It's late. I apologise.
    newGrid = HashDict.merge(grid, fpiece, fn(_k, v1, v2) -> Enum.uniq(v1 ++ v2) end)
    deletedRows = newGrid |> Enum.to_list |> Enum.filter(fn {k,v} -> length(v) == 10) |> Enum.map(fn {k,v} -> k)
    newGrid = newGrid |> Enum.to_list |> Enum.filter(fn {k,v} -> length(v) != 10)
    newGrid = newGrid |> Enum.map(fn {k,v} -> {k - length(Enum.filter(deletedRows, fn x -> x < k end))})
    case length(deletedRows) do
      1 -> {newGrid, 100}
      2 -> {newGrid, 200}
      3 -> {newGrid, 400}
      4 -> {newGrid, 800}
  end
end
