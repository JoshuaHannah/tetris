defmodule Tetris.Grid do

  def new() do
    new
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
            |> Enum.into(new)
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
              |> Enum.into(new)
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

  def onCollision(grid, fpiece) do
    newGrid = pieceCons(fpiece, grid)
    deletedRows = newGrid |> Enum.to_list |> Enum.filter(fn {_k,v} -> length(v) == 10 end) |> Enum.map(fn {k,_v} -> k end)
    newGrid = newGrid |> Enum.to_list |> Enum.filter(fn {_k,v} -> length(v) != 10 end)
    newGrid = newGrid |> Enum.map(fn {k,_v} -> {k - length(Enum.filter(deletedRows, fn x -> x < k end))} end)
    case length(deletedRows) do
      0 -> {newGrid, 0}
      1 -> {newGrid, 100}
      2 -> {newGrid, 200}
      3 -> {newGrid, 400}
      4 -> {newGrid, 800}
    end
  end

  @doc ~S"""
  I'm not proud of the following code
  """

  def rotate(%Tetris.Game{grid: grid, pieces: pieces, points: points} do
    [fpiece | rpieces] = pieces
    {_, {_, pieceid}} = fpiece |> Enum.to_list |> :lists.last
    {grid, [rotate(fpiece, pieceid) | rpieces], points}
  end

  def rotate(piece, pieceid) do
    blocks = piece |> Enum.to_list |> :lists.droplast
    colour information |> Enum.to_list |> :lists.last
    case pieceid do
      :line ->
        case length(blocks) do
          1 ->
            [{a, [b,c,d,e]}] = blocks
            [{a, [c]}, {a-1, [c]}, {a-2, [c]}, {a-3, [c]}] ++ colour |> Enum.into(new)

          _ ->
            [{a, [c]}|_] = blocks
            [{a, [c-1, c, c+1, c+2]}]
        end

      :square ->
        piece

      :rF ->
        case length(blocks) do
          3 ->
            [_, {a, [b,c]}, _] = blocks
            [{a,[b,c]}, {a+1, [c, c+1]}] ++ colour |> Enum.into(new)

          _ ->
            [{a, [b,c]}, _] = blocks
            [{a+1, [b]}, {a, [b,c]}, {a-1, [c]}] ++ colour |> Enum.into(new)
        end

      :lF ->
        case length(blocks) do
          3 ->
            [_, {a, [b,c], _}] = blocks
            [{a, [b,c]}, {a-1, [c, c+1]}] ++ colour |> Enum.into(new)

          _ ->
            [{a,[b,c]}, _] = blocks
            [{a+1, [c]}, {a, [b,c]}, {a-1, [b]}] ++ colour |> Enum.into(new)
        end

      :lL ->
        case length(blocks) do
          3 ->
            [{a,b}, {c,d}, {e,f}] = blocks
            case length(b) ->
              2 ->
                [g,h] = b
                [{c, [g-1, g, h]}, {e,[h]}] ++ colour |> Enum.into(new)

              _ ->
                [g,h] = f
                [{c, [g]}, {e, [g,h,h+1]}] ++ colour |> Enum.into(new)
            end

          _ ->
            [{a,b}, {c,d}] = blocks
            case length(d) do
              3 ->
                [e,f,g] = d
                [{a+1, [e]},{a, [e]},{c, [e,f]}] ++ colour |> Enum.into(new)

              _ ->
                [e,f,g] = b
                [{a+1, [f]},{a, [f]},{c, [e,f]}] ++ colour |> Enum.into(new)
            end
        end


      :rL ->
        case length(blocks) do
          3 ->
            [{a,b}, {c,d}, {e,f}] = blocks
            case length(b) ->
              2 ->
                [g,h] = b
                [{e, [g-1]}, {c, [g-1, g, h]}] ++ colour |> Enum.into(new)

              _ ->
                [g,h] = f
                [{c, [h]},{e, {g-1,g,h}}] ++ colour |> Enum.into(new)
            end
          _ ->
            [{a,b}, {c,d}] = blocks
            case length(d) do
              3 ->
                [e,f,g] = d
                [{a+1, [e]}, {a, [e]}, {c, [e,f]}] ++ colour |> Enum.into(new)

              _ ->
                [e,f,g] = b
                [{a+1, [e,f]},{a, [f]},{c, [f]}] ++ colour |> Enum.into(new)
            end
        end

      :middle ->
        case length(blocks) do
          3 ->
            [{a,[b]}, {c,[d,e]}, {f,[g]}] = blocks
            case b < e do
              true ->
                [{c,[d-1, d, e]}, {f, [d]}] ++ colour |> Enum.into(new)

              _ ->
                [{c, [d]}, {f, [d-1,d,e]}] ++ colour |> Enum.into(new)
            end

          _ ->
            [{a,b}, {c,d}] = blocks
            case length(d) do
              3 ->
                [e,f,g] = d
                [{a+1, [e]}, {a, [e,f]}, {c, [e]}] ++ colour |> Enum.into(new)

              _ ->
                [e,f,g] = b
                [{a+1, [f]},{a, [e,f]},{c, [f]}] ++ colour |> Enum.into(new)                
            end
        end



    end
  end
end
