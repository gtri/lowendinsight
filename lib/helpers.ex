defmodule Helpers do

  @doc """
  get_slug: extracts the slug from the URI

  # Example
      iex(1)> {:ok, slug} = Helpers.get_slug("https://github.com/kitplummer/xmpprails")
      {:ok, "kitplummer/xmpprails"}
      iex(2)> slug
      "kitplummer/xmpprails"
  """
  def get_slug(url) do
    uri = URI.parse(url)
    case uri.path do
      nil ->
        {:error, "invalid source URL"}
      path ->
        path = String.slice(path, 1..-1)
        {:ok, path}
    end
  end

  @doc """
  split_slug: splits apart the username and repo from a git slug.

  ## Examples

      iex(6)> {:ok, org, repo}  = Helpers.split_slug("kitplummer/xmpprails")
      {:ok, "kitplummer", "xmpprails"}
      iex(7)> org
      "kitplummer"
      iex(8)> repo
      "xmpprails"

  """
  def split_slug(slug) do
    if String.contains?(slug, "/") do

      v = String.split(slug, "/")
      {:ok, Enum.at(v, 0), Enum.at(v, 1)}
    else
      {:error, "bad_slug"}
    end
  end

end
