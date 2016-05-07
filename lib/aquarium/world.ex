defmodule Aquarium.World do

  @min_cell 0
  @max_cell 9
  @agent_name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{tangerine: {3, 4}} end, name: @agent_name)
  end

  def min_cell(), do: @min_cell

  def max_cell(), do: @max_cell

  def all_fish() do
    fish = Agent.get(@agent_name, fn fish -> :timer.sleep(1000)
    fish end)
    fish
  end

  def move_fish(fish, direction) do
    Agent.cast(@agent_name, fn all_fish -> move(all_fish, fish, direction) end)
  end

  defp move(all_fish, fish, direction) do
    :timer.sleep(1000)
    IO.inspect self()
    IO.inspect direction
    {x, y} = next(direction, where_is(all_fish, fish))
    Aquarium.Endpoint.broadcast! "aquarium:state", "fish_moved", %{fish: fish, place: %{x: x, y: y}}
    %{ all_fish | fish => {x, y}}
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
