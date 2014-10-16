defmodule Tetris.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(nil) do
    children = [
      worker(Tetris.Driver, []),
      worker(Tetris.Game, [Tetris.Game.new])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
