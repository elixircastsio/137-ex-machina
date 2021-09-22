defmodule Teacher.RecordingsTest do
  use Teacher.DataCase

  alias Teacher.Recordings

  describe "albums" do
    alias Teacher.Recordings.Album

    @valid_attrs %{artist: "some artist", summary: "some summary", title: "some title", year: 1972}
    @update_attrs %{artist: "some updated artist", summary: "some updated summary", title: "some updated title", year: 1973}
    @invalid_attrs %{artist: nil, summary: nil, title: nil, year: nil}

    setup do
      {:ok, album} =
        %{artist: "some artist", summary: "some summary", title: "some title", year: 1972}
        |> Recordings.create_album()

      {:ok, album: album}
    end

    test "list_albums/0 returns all albums", %{album: album} do
      assert Recordings.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id", %{album: album} do
      assert Recordings.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Recordings.create_album(@valid_attrs)
      assert album.artist == "some artist"
      assert album.summary == "some summary"
      assert album.title == "some title"
      assert album.year == 1972
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recordings.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album", %{album: album} do
      assert {:ok, %Album{} = album} = Recordings.update_album(album, @update_attrs)
      assert album.artist == "some updated artist"
      assert album.summary == "some updated summary"
      assert album.title == "some updated title"
      assert album.year == 1973
    end

    test "update_album/2 with invalid data returns error changeset", %{album: album} do
      assert {:error, %Ecto.Changeset{}} = Recordings.update_album(album, @invalid_attrs)
      assert album == Recordings.get_album!(album.id)
    end

    test "delete_album/1 deletes the album", %{album: album} do
      assert {:ok, %Album{}} = Recordings.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Recordings.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset", %{album: album} do
      assert %Ecto.Changeset{} = Recordings.change_album(album)
    end
  end

  describe "reviews" do
    alias Teacher.Recordings.Review

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    setup do
      {:ok, album} =
        %{artist: "some artist", summary: "some summary", title: "some title", year: 1972}
        |> Recordings.create_album()
      {:ok, review} = Recordings.create_review(album, %{body: "a great album"})

      {:ok, album: album, review: Repo.preload(review, :album)}
    end

    test "list_reviews/1 returns all reviews", %{album: album, review: review} do
      assert Recordings.list_reviews(album.id) == [review]
    end

    test "get_review!/1 returns the review with given id", %{review: review} do
      assert Recordings.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review", %{album: album} do
      assert {:ok, %Review{} = review} = Recordings.create_review(album, @valid_attrs)
      assert review.body == "some body"
    end

    test "create_review/1 with invalid data returns error changeset", %{album: album} do
      assert {:error, %Ecto.Changeset{}} = Recordings.create_review(album, @invalid_attrs)
    end

    test "update_review/2 with valid data updates the review", %{review: review} do
      assert {:ok, %Review{} = review} = Recordings.update_review(review, @update_attrs)
      assert review.body == "some updated body"
    end

    test "update_review/2 with invalid data returns error changeset", %{review: review} do
      assert {:error, %Ecto.Changeset{}} = Recordings.update_review(review, @invalid_attrs)
      assert review == Recordings.get_review!(review.id)
    end

    test "delete_review/1 deletes the review", %{review: review} do
      assert {:ok, %Review{}} = Recordings.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Recordings.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset", %{review: review} do
      assert %Ecto.Changeset{} = Recordings.change_review(review)
    end
  end
end
