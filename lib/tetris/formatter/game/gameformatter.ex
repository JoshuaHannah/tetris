defmodule Tetris.Game.Formatter do

  def format(%{points: points, grid: grid, pieces: pieces} =game) do
    [IO.ANSI.home,
    IO.ANSI.clear,
    format_score(game),
    format_grid(game),
    IO.ANSI.reset]
  end

  def format_score(%{points: points, grid: grid, pieces: pieces}) do

  end

  def format_grid(%{points: points,grid: grid, pieces: pieces}) do
    
  end
end
