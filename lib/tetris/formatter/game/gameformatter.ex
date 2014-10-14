defmodule Tetris.Game.Formatter do
  def format(%Tetris.Game{} = game) do
    [IO.ANSI.home,
    IO.ANSI.clear,
    format_score(game),
    format_grid(game),
    IO.ANSI.reset]
  end

  defp format_score(%{points: points}) do
    ["  points: ", Integer.to_string(points), "\r\n\r\n"]
  end

  defp format_grid(%{grid: grid}) do
    Tetris.Grid.Formatter.format(grid)
  end
end
