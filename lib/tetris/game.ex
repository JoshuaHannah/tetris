defmodule Tetris.Game do

  defstruct [:grid, :pieces, points: 0]

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: :game])
  end

  def init(%__MODULE__{} = state) do
    {:ok, state, 1}
  end

  def move(key) do
    GenServer.cast(:game, {:keystroke, key})
  end

  def handle_cast({:keystroke, key}, %__MODULE__{} = state) do
    {:noreply, Grid.keystroke(state, key), 0}
  end

  def handle_info(:timeout, %__MODULE__{} = state) do
    __MODULE__.Formatter.format(state)
    |> IO.write
  end

  defp move(%__MODULE__{grid: state, points: points}, direction) do
    {grid, pieces, points} = Grid.move({grid, pieces, direction})

    %__MODULE__{grid: grid, pieces: pieces, points: points}
  end



end
