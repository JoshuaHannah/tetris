defmodule Tetris.Grid do

  defdelegate format(grid), to: __MODULE__.Formatter

  @doc ~S"""
  Pattern matches the keystroke to identify what action should be taken
  on the active piece.
  """

  def keystroke(%Tetris.Game{grid: grid, pieces: pieces, points: points} = state, key) do
    case key do
      :space ->
         {new_grid, new_pieces, new_points} = drop(grid, pieces)
         %Tetris.Game{grid: new_grid, pieces: new_pieces, point: points + new_points}
      :up ->
         {new_pieces} = rotate(piece, key)
         %Tetris.Game{grid: grid, pieces: new_pieces, point: points}
      _ ->
         {new_grid, new_pieces, new_points} = move(piece, grid, key)
         %Tetris.Game{grid: new_grid, pieces: new_pieces, point: points + new_points}
    end
  end

  @doc ~S"""
  Moves the active piece the corresponding direction.
  Returns {grid, pieces, points}.
  """

  def move([piece | rpiece] = pieces, grid, direction) do
    case direction do
      :down ->
        if invalid_position?(grid, down_piece(piece)) do
          add_piece(pieces, grid)
        else
          {grid, [down_piece(piece) | rpiece], 0}
        end

      :right ->
        if invalid_position?(grid, right_piece(piece)) do
          {grid, pieces, 0}
        else
          {grid, [right_piece(piece) | rpieces], 0}
        end

      :left ->
        if invalid_position?(grid, left_piece(piece)) do
          {grid, pieces, 0}
        else
          {grid, [left_piece(piece) | rpieces], 0}
    end
  end

  @doc ~S"""
  Following three functions make code cleaner.
  """
  defp down_piece(piece) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k-1, v} end)
    ++ piece_info
  end

  defp right_piece([]) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k, Enum.map(v, fn x -> x + 1 end)} end)
    ++ piece_info
  end

  defp left_piece([]) do
    {piece_coords, piece_info} = piece |> split

    piece_coords
    |> Enum.map(fn {k,v} -> {k, Enum.map(v, fn x -> x - 1 end)} end)
    ++ piece_info
  end

  defp split(piece) do
    piece |> Enum.split_while(fn {_k,v} -> :erlang.is_list(v) end)
  end

  def invalid_position?(grid, piece) do
    out_of_bounds?(piece)
    or grid_piece_overlap(grid, piece)
    or hits_bottom(grid, piece)
  end

  def out_of_bounds?(piece) do
    {grid_coords, _} = piece |> split

    grid_coords |> Enum.map(fn {k,v} -> Enum.member(v, 0) or Enum.member(v, 11) end) |> Enum.any?
  end

  def grid_piece_overlap?(grid, piece) do

  end

  def hits_bottom(grid, piece) do

  end

  def add_piece([piece|rpieces], grid) do

  end

  def placement?(grid, piece) do

  end

  def reduce_grid(grid) do

  end


  def rotate(piece, key) do

  end

  @doc ~S"""
    Arguments: Grid :: [{k,v}], Pieces :: HashDict({k,v})

    Returns: {Grid, Pieces, newPoints :: Int}
  """
  def drop(grid, pieces) do

  end
end
