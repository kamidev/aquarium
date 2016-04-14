defmodule Aquarium.FreeFish do

  @agent_name __MODULE__

  def start_link do
    Agent.start_link(fn -> [ :tangerine, :yellow, :blue, :cooked, :red, :puffer, :teal ] end, name: @agent_name)
  end

  def get_free_fish do
    Agent.get_and_update(@agent_name, fn free_fish -> pop_fish(free_fish) end)
  end

  def return_fish(fish) do
    Agent.update(@agent_name, fn free_fish -> push_fish(fish, free_fish) end)
  end

  defp pop_fish([]) do
    {nil, []}
  end
  defp pop_fish([ first | rest ]) do
    {first, rest}
  end

  defp push_fish(fish, free_fish) do
    [ fish | free_fish ]
  end

end
