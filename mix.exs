defmodule Tetris.Mixfile do
  use Mix.Project

  def project do
    [app: :tetris,
     version: "0.0.1",
     elixir: "~> 1.0.0"]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [],
     mod: {Tetris, {}}]
  end
end
