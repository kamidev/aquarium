defmodule Aquarium.Fish do
  alias Aquarium.World

  @min_cell 0
  @max_cell 9

  def start_link(fish_name, initial_place) do
    IO.inspect(to_string(fish_name) <> " (re)born")
    Agent.start_link(fn -> initial_place end, name: fish_name)
  end

  def min_cell(), do: @min_cell

  def max_cell(), do: @max_cell

  def move(fish_name, direction) do
    Agent.get_and_update(fish_name, fn place -> move_from(direction, place) end)
  end

  def where_is(fish_name) do
    Agent.get(fish_name, fn place -> place end)
  end

  defp move_from(direction, from) do
    place = next(direction, from)
    {place , place}
  end

  defp next("up", {x, y}) do
    {x, one_less(y)}
  end
  defp next("down", {x, y}) do
    {x, one_more(y)}
  end
  defp next("left", {x, y}) do
    {one_less(x), y}
  end
  defp next("right", {x, y}) do
    {one_more(x), y}
  end

  defp one_less(@min_cell) do
    @min_cell
  end
  defp one_less(i) do
    i - 1
  end

  defp one_more(@max_cell) do
    @max_cell
  end
  defp one_more(i) do
    i + 1
  end

end
