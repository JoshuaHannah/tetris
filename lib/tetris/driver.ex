defmodule Tetris.Driver do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    {:ok, Port.open({:spawn, 'tty_sl -c -e'}, [:eof])}
  end

  def handle_info({pid, {:data, data}}, pid) do
    if direction = keystroke(data) do
      Tetris.Game.move(direction)
    end

    {:noreply, pid}
  end

  defp keystroke(' '), do: :space

  defp keystroke('\e[A'), do: :up

  defp keystroke('\e[B'), do: :down

  defp keystroke('\e[C'), do: :right

  defp keystroke('\e[D'), do: :left

  defp keystroke(_),  do: nil
end
