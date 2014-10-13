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

    def move(%Game{grid: grid, pieces: pieces, points: points}, direction) do
      @doc ~S"""
      Moves the active piece the corresponding direction.
      """

    end

    end
  end
end
