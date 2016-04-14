defmodule Aquarium.PageController do
  use Aquarium.Web, :controller
  alias Aquarium.World

  def index(conn, _params) do
    render conn, "index.html", fish: World.all_fish, min_cell: World.min_cell, max_cell: World.max_cell
  end

end
