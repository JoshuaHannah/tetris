defmodule Tetris.Grid do

  @doc ~S"""
  Pattern matches the keystroke to identify what action should be taken
  on the active piece.
  """

  def keystroke(%Tetris.Game{grid: grid, pieces: pieces, points: points} = state, key) do
    case key do
      :space ->
         {new_grid, new_pieces, new_points} = drop(grid, pieces)
         %Tetris.Game{grid: new_grid, pieces: new_pieces, points: points + new_points}
      :up ->
         {new_pieces} = rotate(pieces, grid)
         %Tetris.Game{grid: grid, pieces: new_pieces, points: points}
      _ ->
         {new_grid, new_pieces, new_points} = move(pieces, grid, key)
         %Tetris.Game{grid: new_grid, pieces: new_pieces, points: points + new_points}
    end
  end

  @doc ~S"""
  Moves the active piece the corresponding direction.
  Returns {grid, pieces, points}.
  """

  defp move([piece | rpieces] = pieces, grid, direction) do
    case direction do
      :down ->
        if invalid_position(grid, down_piece(piece)) do
          add_piece(pieces, grid)
        else
          {grid, [down_piece(piece) | rpieces], 0}
        end

      :right ->
        if invalid_position(grid, right_piece(piece)) do
          {grid, pieces, 0}
        else
          {grid, [right_piece(piece) | rpieces], 0}
        end

      :left ->
        if invalid_position(grid, left_piece(piece)) do
          {grid, pieces, 0}
        else
          {grid, [left_piece(piece) | rpieces], 0}
        end
    end
  end

  @doc ~S"""
  Following three functions make code cleaner.
  """

  defp down_piece(piece) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k-1, v} end)
    |> :lists.append(piece_info)
  end

  defp right_piece(piece) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k, Enum.map(v, fn x -> x + 1 end)} end)
    |> :lists.append(piece_info)
  end

  defp left_piece(piece) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k, Enum.map(v, fn x -> x - 1 end)} end)
    |> :lists.append(piece_info)
  end

  def split(piece) do
    piece |> Enum.split_while(fn {_k,v} -> :erlang.is_list(v) end)
  end

  defp invalid_position(grid, piece) do
    out_of_bounds?(piece) or grid_piece_overlap?(grid, piece) or hits_bottom(grid, piece)
  end

  defp out_of_bounds?(piece) do
    {grid_coords, _} = piece |> split

    grid_coords |> Enum.map(fn {k,v} -> Enum.member?(v, 0) or Enum.member?(v, 11) end) |> Enum.any?
  end

  defp grid_piece_overlap?(grid, piece) do
    {piece_coords, piece_info} = piece |> split
    grid_coords = grid |> Enum.map(fn {k,v,c} -> {k,v} end)
    piece_coords_list = piece_coords |> Enum.map(fn {k,v} -> Enum.map(v, fn x -> {k,x} end) end) |> :lists.flatten
    piece_coords_list |> Enum.map(fn x -> Enum.member?(grid_coords, x) end) |> Enum.any?
  end

  defp hits_bottom(grid, piece) do
    {piece_coords, _} = piece |> split
    piece_coords |> Enum.map(fn {k,v} -> k == 0 end) |> Enum.any?
  end

  @doc ~S"""
  Takes pieces and grid.. Returns {grid, pieces, points}
  """

  defp add_piece([piece|rpieces], grid) do
    {piece_coords, piece_info} = piece |> split
    [{0, colour}] = piece_info |> Enum.filter(fn {k,v} -> k == 0 end)

    {newGrid, points} =
    piece_coords
    |> Enum.map(fn {k,v} -> Enum.map(v, fn x -> {k,x, colour} end) end)
    |> :lists.flatten
    |> :lists.append(grid)
    |> reduce_grid(1,0)

    newPieces = rpieces ++ [Tetris.Pieces.new_piece]

    {newGrid, newPieces, points}
  end

  defp reduce_grid(grid, row , no) do
    is_full = (grid |> Enum.filter(fn {k,v,c} -> k == row end) |> length) == 10

    if is_full do
      grid
      |> Enum.filter(fn {k,v,c} -> k != row end)
      |> Enum.map(fn {k,v,c} -> if k > row, do: {k-1, v, c}, else: {k,v,c} end)
      |> reduce_grid(row, no+1)
    else
      if row > 20 do
        {grid, no}
      else
        reduce_grid(grid, row+1, no)
      end
    end
  end

  defp power(m, n) do
    case n<1 do
      true ->
        m
      _ ->
        m*power(m, n-1)
    end
  end

  @doc ~S"""
  Takes pieces and returns new pieces, with the active piece rotated.
  """
  defp rotate([piece | rpieces] = old_pieces, grid) do
    {piece_id, rotation} = {piece |> Enum.into(%{}) |> Dict.get(-1), piece |> Enum.into(%{}) |> Dict.get(-2)}

    {piece_coords, piece_info} = piece |> split

    rotated_piece_info = piece_info |> Enum.map(fn {k,v} -> if k == -2, do: {k, rem(v+1, 4)}, else: {k,v} end)

    case piece_id do
      :line ->
        case rem(rotation,2) do
          0 ->
            [{a, [b,c,d,e]}] = piece_coords
            new_piece = [{a+1, [c]}, {a, [c]}, {a-1, [c]}, {a-2, [c]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{a, [b]}, {c, [b]}, {d, [b]}, {e, [b]}] = piece_coords
            new_piece = [{c, [b-1,b,b+1,b+2]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end

      :square ->
        {old_pieces}

      :rF ->
        case rem(rotation, 2) do
          0 ->
            [{a, [d]}, {b, [d,e]}, {c, [e]}] = piece_coords
            new_piece = [{b, [e, e+1]}, {c, [d,e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{b, [e, f]}, {c, [d,e]}] = piece_coords
            new_piece = [{b+1, [d]}, {b, [d,e]}, {c, [e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end

      :lF ->
        case rem(rotation, 2) do
          0 ->
            [{a, [f]}, {b, [e,f]}, {c, [e]}] = piece_coords
            new_piece = [{b, [e, f]}, {c, [f, f+1]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{b, [e, f]}, {c, [f, g]}] = piece_coords
            new_piece = [{b+1, [f]}, {b, [e,f]}, {c, [e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end
      :rL ->
        case rotation do
          0 ->
            [{a, [d]}, {b, [d]}, {c, [d,e]}] = piece_coords
            new_piece = [{b, [d-1, d, e]}, {c, [d-1]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{b, [f, d, e]}, {c, [f]}] = piece_coords
            new_piece = [{b+1, [f, d]}, {b, [d]}, {c, [d]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          2 ->
            [{a, [f, d]}, {b, [d]}, {c, [d]}] = piece_coords
            new_piece = [{b, [d+1]}, {c, [f, d, d+1]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          3 ->
            [{b, [e]}, {c, [f, d, e]}] = piece_coords
            new_piece = [{b+1, [d]}, {b, [d]}, {c, [d,e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end

      :lL ->
        case rotation do
          0 ->
            [{a, [e]}, {b, [e]}, {c, [d,e]}] = piece_coords
            new_piece = [{b, [d-1]}, {c, [d-1, d, e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{b, [f]}, {c, [f, d, e]}] = piece_coords
            new_piece = [{b+1, [d,e]}, {b, [d]}, {c, [d]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          2 ->
            [{a, [d,e]}, {b, [d]}, {c, [d]}] = piece_coords
            new_piece = [{b, [d-1, d, e]}, {c, [e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          3 ->
            [{b, [f, d, e]}, {c, [e]}] = piece_coords
            new_piece = [{b+1, [e]}, {b, [e]}, {c, [d,e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end

      :middle ->
        case rotation do
          0 ->
            [{b, [d]}, {c, [f,d,e]}] = piece_coords
            new_piece = [{b+1, [f]}, {b, [f,d]}, {c, [f]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          1 ->
            [{a, [f]}, {b, [f,d]}, {c, [f]}] = piece_coords
            new_piece = [{b, [f, d, d+1]}, {c, [d]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          2 ->
            [{b, [f, d, e]}, {c, [d]}] = piece_coords
            new_piece = [{b+1, [e]}, {b, [d, e]}, {c, [e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end

          3 ->
            [{a, [e]}, {b, [d, e]}, {c, [e]}] = piece_coords
            new_piece = [{b, [d]}, {c, [d-1,d,e]}] ++ rotated_piece_info
            if invalid_position(grid, new_piece) do
              {old_pieces}
            else
              {[new_piece | rpieces]}
            end
        end
    end
  end

  @doc ~S"""
    Arguments: Grid :: [{k,v}], Pieces :: HashDict({k,v})
    Returns: {Grid, Pieces, newPoints :: Int}
  """
  defp drop(grid, [piece | rpieces] = pieces) do
    {piece_coords, piece_info} = piece |> split
    new_piece = (piece_coords |> Enum.map(fn {k,v} -> {k-1, v} end)) ++ piece_info

    if invalid_position(grid, new_piece) do
      add_piece(pieces, grid)
    else
      drop(grid, [new_piece | rpieces])
    end
  end

end
