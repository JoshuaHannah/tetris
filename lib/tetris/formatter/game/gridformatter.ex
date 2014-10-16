defmodule Tetris.Grid.Formatter do

  def format(grid, [piece | _rpieces]) do
    20..1
    |> Enum.to_list
    |> Enum.map(fn x -> {HashDict.get(grid, x), HashDict.get(piece, x), HashDict.get(piece, 0)} end)
    |> Enum.map(&to_rows(&1))
    |> :lists.flatten
    |> IO.ANSI.format_fragment
  end

  def to_rows({nil,nil,_}) do
    "\r\n"
  end

  def to_rows({a, nil, _}) do
    1..10
    |> Enum.to_list
    |> Enum.map(fn x ->
       if Enum.member?(a,x) do
          [:white, "#"]
       else
         ""
      end
    end)
  end

  def to_rows({nil, a, nil}) do
    to_rows({nil, a, {:blue, :hello}})
  end

  def to_rows({nil, b, {c,_}}) do
    1..10
    |> Enum.to_list
    |> Enum.map(fn x ->
      if Enum.member?(b,x) do
        [c, "#"]
      else
        " "
      end
    end)
  end

  def to_rows({a,b,{c,_}}) do
    1..10
    |> Enum.to_list
    |> Enum.map(fn x ->
       if Enum.member?(a,x) do
          [:white, "#"]
       else
         if Enum.member?(b,x) do
           [c, "#"]
         else
           " "
         end
       end
     end)
  end
end
