defmodule UrlShortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :short_path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :short_path])
    |> validate_required([:url, :short_path])
    |> unique_constraint(:short_path)
    |> unique_constraint(:url)
  end
end
