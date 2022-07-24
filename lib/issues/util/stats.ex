defmodule Issues.Util.Stats do
  def sum(vals), do: vals |> Enum.sum()
  def count(vals), do: vals |> length()
  def average(vals), do: sum(vals) / count(vals)
end
