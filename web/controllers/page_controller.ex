defmodule Aquarium.PageController do
  use Aquarium.Web, :controller
  alias Aquarium.WorldState

  def index(conn, _params) do
    render conn, "index.html", fish: %{ :tangerine => {3, 4} }, min_cell: 0, max_cell: 9
  end

end
