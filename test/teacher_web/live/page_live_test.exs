defmodule TeacherWeb.PageLiveTest do
  use TeacherWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Hello world"
    assert render(page_live) =~ "Hello world"
  end
end
