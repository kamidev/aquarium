defmodule Aquarium.AquariumChannel do
  use Phoenix.Channel

  @min_cell 0
  @max_cell 9

  def join("aquarium:state", _message, socket) do
    {:ok, socket }
  end

  def handle_in("move_fish", %{"dir" => dir, "fish" => fish, "place" => %{"x" => x, "y" => y}}, socket) do
    {new_x, new_y} = next dir, {x, y}
    broadcast! socket, "fish_moved", %{fish: fish, place: %{x: new_x, y: new_y}}
    {:noreply, socket}
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

  defp one_less(@min_cell), do: @min_cell
  defp one_less(i), do: i - 1

  defp one_more(@max_cell), do: @max_cell
  defp one_more(i), do: i + 1

end
