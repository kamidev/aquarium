defmodule Aquarium.AquariumChannel do
  use Phoenix.Channel
  alias Aquarium.World

  def join("aquarium:state", _message, socket) do
    {:ok, socket }
  end

  def handle_in("move_fish", %{"dir" => dir, "fish" => fish}, socket) do
    {x, y} = World.move_fish String.to_atom(fish), dir
    broadcast! socket, "fish_moved", %{fish: fish, place: %{x: x, y: y}}
    {:noreply, socket}
  end

end
