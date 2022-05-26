defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Get Started"
  end

  test "GET /init", %{conn: conn} do
    conn = get(conn, "/init")
    assert html_response(conn, 200) =~ "Get Started"
  end
end
