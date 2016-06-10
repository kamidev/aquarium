defmodule Aquarium.PageControllerTest do
  use Aquarium.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "The Aquarium"
  end
end
