defmodule Aquarium.World do
  use Supervisor
  alias Aquarium.Fish

  @supervisor_name :mother_of_fish

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: @supervisor_name)
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end

  def min_cell(), do: Fish.min_cell

  def max_cell(), do: Fish.max_cell

  def all_fish() do
    list_fish
    |> Enum.map(fn fish -> {fish, Fish.where_is(fish)} end)
    |> Enum.into(%{})
  end

  def add_fish(fish) do
    place = {0, 0}
    Supervisor.start_child(@supervisor_name, worker(Fish, [fish, place], id: fish))
    {fish, place}
  end

  def remove_fish(fish) do
    Supervisor.terminate_child(@supervisor_name, fish)
    Supervisor.delete_child(@supervisor_name, fish)
    fish
  end

  def move_fish(fish, direction) do
    new_place = Fish.move(fish, direction)
    killed_fish = detect_killings(new_place, fish)
    kill_fish(killed_fish)
    { killed_fish, new_place}
  end

  defp list_fish() do
    Supervisor.which_children(@supervisor_name)
    |> Enum.map(fn tuple -> elem(tuple, 0) end)
  end

  defp detect_killings(place, killer) do
    list_fish
    |> Enum.filter(fn fish -> fish != killer end)
    |> Enum.find(nil, fn fish -> Fish.where_is(fish) == place end)
  end

  defp kill_fish(nil) do end
  defp kill_fish(fish) do
    IO.inspect(to_string(fish) <> " killed")
    Process.whereis(fish)
    |> Process.exit(:kill)
  end

end
