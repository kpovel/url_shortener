defmodule UrlShortener.Repo do
  use Ecto.Repo,
    otp_app: :url_shortener,
    adapter: Ecto.Adapters.SQLite3
end
