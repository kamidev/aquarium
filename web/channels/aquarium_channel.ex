defmodule Aquarium.AquariumChannel do
  use Phoenix.Channel
  alias Aquarium.FreeFish
  alias Aquarium.World

  def join("aquarium:state", _message, socket) do
    {fish, {x, y}} = FreeFish.get_free_fish()
    |> add_fish_to_world
    {:ok, %{ :fish => fish, :place => %{x: x, y: y}}, Phoenix.Socket.assign(socket, :fish, fish) }
  end

  def handle_in("move_fish", %{"dir" => dir, "fish" => fish}, socket) do
    {x, y} = World.move_fish String.to_atom(fish), dir
    broadcast! socket, "fish_moved", %{fish: fish, place: %{x: x, y: y}}
    {:noreply, socket}
  end

  def handle_in("fish_added", message, socket) do
    broadcast! socket, "fish_added", message
    {:noreply, socket}
  end

  def terminate(_message, socket) do
    fish = socket.assigns.fish
    World.remove_fish(fish)
    FreeFish.return_fish(fish)
    broadcast! socket, "fish_removed", %{fish: fish}
  end

  defp add_fish_to_world(nil) do
    {nil, {-1, -1}}
  end
  defp add_fish_to_world(fish) do
    World.add_fish(fish)
  end

end
