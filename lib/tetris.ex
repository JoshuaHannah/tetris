defmodule Tetris do
  use Application

  def start(_type, _args) do
    {n1, n2, n3} = :erlang.now
    :random.seed(n1, n2, n3)

    Tetris.Supervisor.start_link
  end
end
