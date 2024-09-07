defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :short_path, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:short_path])
    create unique_index(:links, [:url])
  end
end
