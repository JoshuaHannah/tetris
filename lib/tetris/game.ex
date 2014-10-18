defmodule Tetris.Game do

  defstruct [:grid, :pieces, points: 0]

  alias Tetris.Grid

  use GenServer

  def new() do
    %__MODULE__{grid: [], pieces: Tetris.Pieces.new}
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: :game])
  end

  def init(%__MODULE__{} = state) do
    loop()
    {:ok, state, 1}
  end

  defp loop() do
    spawn(fn ->
      receive do
      after
        500 ->
          move(:down)
          loop()
        end
      end)
  end

  def move(key) do
    GenServer.cast(:game, {:keystroke, key})
  end

  def handle_cast({:keystroke, key}, %__MODULE__{} = state) do
    {:noreply, Grid.keystroke(state, key), 0}
  end

  def handle_info(:timeout, state) do
    __MODULE__.Formatter.format(state)
    |> IO.write

  {:noreply, state}
  end

end
