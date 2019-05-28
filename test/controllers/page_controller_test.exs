defmodule Aquarium.PageControllerTest do
  use Aquarium.ConnCase

  test "GET /", %{conn: _} do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "The Aquarium"
  end
end
