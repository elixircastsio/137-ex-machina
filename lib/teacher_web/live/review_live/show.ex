defmodule TeacherWeb.ReviewLive.Show do
  use TeacherWeb, :live_view

  alias Teacher.Recordings

  @impl true
  def mount(%{"album_id" => album_id}, _session, socket) do
    album = Recordings.get_album!(album_id)

    {:ok, assign(socket, album: album)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:review, Recordings.get_review!(id))}
  end

  defp page_title(:show), do: "Show Review"
  defp page_title(:edit), do: "Edit Review"
end
