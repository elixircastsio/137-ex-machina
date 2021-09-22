defmodule Teacher.Recordings.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :body, :string
    belongs_to :album, Teacher.Recordings.Album

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
