defmodule UrlShortener.Link do
  alias UrlShortener.Repo
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  @short_path_len 5
  @allowed_tokens "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

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

  def find_url_by_short_path(short_path) do
    from(UrlShortener.Link,
      where: [short_path: ^short_path],
      select: [:url]
    )
    |> Repo.one()
  end

  def find_path_by_url(url) do
    from(UrlShortener.Link,
      where: [url: ^url],
      select: [:short_path]
    )
    |> Repo.one()
  end

  def valid_url(url) do
    uri = URI.parse(url)
    uri.scheme != nil
  end

  def generate_short_path() do
    tokens_length = @allowed_tokens |> String.length()
    short_path(@short_path_len, tokens_length)
  end

  defp short_path(0, _rand_tokens_len), do: ""

  defp short_path(reminds, rand_tokens_len) do
    char_at = Enum.random(0..(rand_tokens_len - 1))
    String.at(@allowed_tokens, char_at) <> short_path(reminds - 1, rand_tokens_len)
  end
end
