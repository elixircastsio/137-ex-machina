defmodule TeacherWeb.ReviewLiveTest do
  use TeacherWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Teacher.Repo
  alias Teacher.Recordings

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  defp fixture(:review) do
    {:ok, album} = Recordings.create_album(
      %{artist: "some artist", summary: "some summary", title: "some title", year: 1972}
    )
    {:ok, review} = Recordings.create_review(album, @create_attrs)
    review
  end

  defp create_review(_) do
    review =
      fixture(:review)
      |> Repo.preload(:album)

    %{review: review}
  end

  describe "Index" do
    setup [:create_review]

    test "lists all reviews", %{conn: conn, review: review} do
      {:ok, _index_live, html} = live(conn, Routes.review_index_path(conn, :index, review.album))

      assert html =~ "Listing Reviews"
      assert html =~ review.body
    end

    test "saves new review", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, Routes.review_index_path(conn, :index, review.album))
      assert index_live |> element("a", "Add Review") |> render_click() =~
               "New Review"

      assert_patch(index_live, Routes.review_index_path(conn, :new, review.album))

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#review-form", review: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.review_index_path(conn, :index, review.album))

      assert html =~ "Review created successfully"
      assert html =~ "some body"
    end
  end

  describe "Show" do
    setup [:create_review]

    test "displays review", %{conn: conn, review: review} do
      {:ok, _show_live, html} = live(conn, Routes.review_show_path(conn, :show, review.album, review))

      assert html =~ "Show Review"
      assert html =~ review.body
    end

    test "updates review within modal", %{conn: conn, review: review} do
      {:ok, show_live, _html} = live(conn, Routes.review_show_path(conn, :show, review.album, review))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(show_live, Routes.review_show_path(conn, :edit, review.album, review))

      assert show_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#review-form", review: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.review_show_path(conn, :show, review.album, review))

      assert html =~ "Review updated successfully"
      assert html =~ "some updated body"
    end
  end
end
