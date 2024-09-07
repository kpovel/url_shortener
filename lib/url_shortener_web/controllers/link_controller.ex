defmodule UrlShortenerWeb.LinkController do
  alias UrlShortener.Repo
  alias UrlShortener.Link
  use UrlShortenerWeb, :controller

  def short(%Plug.Conn{} = conn, %{"url" => url}) do
    case Link.valid_url(url) do
      false ->
        conn |> send_resp(400, "invalid url")

      true ->
        {_, host} =
          conn.req_headers
          |> Enum.find(fn {key, _value} -> key == "host" end)

        {:ok, short_path} =
          Repo.transaction(fn ->
            case Link.find_path_by_url(url) do
              %Link{short_path: short_path} ->
                short_path

              nil ->
                short_path = Link.generate_short_path()
                %Link{url: url, short_path: short_path} |> Repo.insert!()
                short_path
            end
          end)

        conn |> send_resp(200, "http://#{host}/api/r/#{short_path}")
    end
  end

  def short(conn, _params) do
    conn |> send_resp(400, "provide a url")
  end

  def redirect(conn, %{"short_path" => short_path}) do
    case Link.find_url_by_short_path(short_path) do
      nil -> conn |> send_resp(404, "url not found")
      %Link{url: url} -> conn |> send_resp(200, url)
    end
  end
end
