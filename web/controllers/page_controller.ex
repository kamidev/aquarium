defmodule Aquarium.PageController do
  use Aquarium.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
