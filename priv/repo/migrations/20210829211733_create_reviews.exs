defmodule Teacher.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :body, :text
      add :album_id, references(:albums, on_delete: :nothing)

      timestamps()
    end

    create index(:reviews, [:album_id])
  end
end
