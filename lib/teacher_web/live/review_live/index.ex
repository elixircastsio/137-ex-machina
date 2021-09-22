defmodule TeacherWeb.ReviewLive.Index do
  use TeacherWeb, :live_view

  alias Teacher.Recordings
  alias Teacher.Recordings.Review

  @impl true
  def mount(%{"album_id" => album_id}, _session, socket) do
    album = Recordings.get_album!(album_id)
    reviews = Recordings.list_reviews(album_id)

    {:ok,
      socket
      |> assign(reviews: reviews)
      |> assign(album: album)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Review")
    |> assign(:review, Recordings.get_review!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Review")
    |> assign(:review, %Review{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reviews")
    |> assign(:review, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Recordings.get_review!(id)
    {:ok, _} = Recordings.delete_review(review)

    {:noreply, assign(socket, :reviews, Recordings.list_reviews(review.album.id))}
  end

end
