defmodule Tetris do
  use Application

  def start(_type, _args) do
    <<n1::32, n2::32, n3::32>> = :crypto.rand_bytes(12)
    :random.seed(n1, n2, n3)

    Tetris.Supervisor.start_link
  end
end
