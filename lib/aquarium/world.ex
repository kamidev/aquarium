defmodule Aquarium.World do
  alias Aquarium.Fish

  @min_cell 0
  @max_cell 9
  @agent_name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{} end, name: @agent_name)
  end

  def min_cell(), do: @min_cell

  def max_cell(), do: @max_cell

  def all_fish() do
    Agent.get(@agent_name, fn fish -> fish end)
  end

  def move_fish(fish, direction) do
    Agent.get_and_update(@agent_name, fn all_fish -> move(all_fish, fish, direction) end)
  end

  def add_fish(fish) do
    initial_place = {3, 4}
    Agent.update(@agent_name, fn all_fish -> Map.put(all_fish, fish, initial_place) end)
    {fish, initial_place}
  end

  def remove_fish(fish) do
    Agent.update(@agent_name, fn all_fish -> Map.delete(all_fish, fish) end)
  end

  defp move(all_fish, fish, direction) do
    place = next(direction, where_is(all_fish, fish))
    { place, %{ all_fish | fish => place }}
  end

  defp where_is(all_fish, fish) do
    all_fish[fish]
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
