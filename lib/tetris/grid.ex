defmodule Tetris.Grid do

  def new() do
    HashDict.new
  end

  @doc ~S"""
  Pattern matches the keystroke to identify what action should be taken
  on the active piece.
  """

  def keystroke(state, key) do
    case key do
      :space ->
         drop(state)
      :up ->
         rotate(state)
      _ ->
        move(state, key)
    end
  end

  @doc ~S"""
  Moves the active piece the corresponding direction.
  Returns {grid, pieces, points}.
  """

  def move(%Tetris.Game{grid: grid, pieces: pieces, points: points}, direction) do
    [fpiece | rpieces] = pieces
    newPiece = fpiece |> Enum.to_list |> :lists.droplast

    case direction do
      :down ->
        downPiece = newPiece |> Enum.map(fn{h, b} -> {h-1, b} end)
        cond do
          invalidposition?(grid, downPiece) ->
            {newGrid, newPoints} = onCollision(grid, fpiece)
            {newGrid, Pieces.update(rpieces), points + newPoints}

          true -> {pieceCons(fpiece, grid), Pieces.update(rpieces), points}
        end

      :right ->
        rightPiece = Enum.map(newPiece, fn {h, b} -> {h, Enum.map(b, fn x -> x + 1 end)} end)
        cond do
          invalidposition?(grid, rightPiece) ->
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
            invalidposition?(grid, leftPiece) ->
              {grid, pieces, points}

            true ->
              newfpiece =
              leftPiece ++ :lists.last(Enum.to_list(fpiece))
              |> Enum.into(HashDict.new)
              {grid, [newfpiece | rpieces], points}
          end
    end
  end

  def invalidposition?(grid, piece) do
    flatPiece = piece |> Enum.map(fn {_h, b} -> b end) |> Enum.flatten

    piece |> Enum.any?(fn x -> Enum.member?(grid, x) end) ||
    flatPiece |> Enum.member?(11) ||
    flatPiece |> Enum.member?(-1)

  end

  def pieceCons(piece, grid) do
    HashDict.merge(grid, piece, fn(_k, v1, v2) -> Enum.uniq(v1 ++ v2) end)
  end

  def onCollision(grid, fpiece) do #Disgusting code. It's late. I apologise.
    newGrid = pieceCons(fpiece, grid)
    deletedRows = newGrid |> Enum.to_list |> Enum.filter(fn {_k,v} -> length(v) == 10 end) |> Enum.map(fn {k,_v} -> k end)
    newGrid = newGrid |> Enum.to_list |> Enum.filter(fn {_k,v} -> length(v) != 10 end)
    newGrid = newGrid |> Enum.map(fn {k,_v} -> {k - length(Enum.filter(deletedRows, fn x -> x < k end))} end)
    case length(deletedRows) do
      1 -> {newGrid, 100}
      2 -> {newGrid, 200}
      3 -> {newGrid, 400}
      4 -> {newGrid, 800}
    end
  end
end
