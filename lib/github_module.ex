defmodule GithubModule do
  @moduledoc """
  Documentation for GithubModule.
  """

  @doc """
  split_slug: splits apart the username and repo from a git slug.

  ## Examples

      iex(6)> {:ok, org, repo}  = GithubModule.split_slug("kitplummer/xmpprails")
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

  @doc """
  get_contributors_count: returns the number of contributors to a repo

  """
  def get_contributors_count(slug) do
    {:ok, org, repo} = split_slug(slug)
    c = Tentacat.Client.new(%{access_token: Application.fetch_env!(:lowendinsight, :access_token)})
    contributors = Tentacat.Repositories.Contributors.list c, org, repo
    if elem(contributors, 0) == 404 do
      {:error, "repo not found"}
    else
      {:ok, elem(contributors, 1) |> Enum.count()}
    end
  end

  @doc """
  get_last_commit_delta: returns the number of days since the last commit

  """
  def get_last_commit_delta(slug) do
    {:ok, org, repo} = split_slug(slug)
    c = Tentacat.Client.new(%{access_token: Application.fetch_env!(:lowendinsight, :access_token)})
    commits = Tentacat.Commits.list(c, org, repo)
    commit = elem(commits,1) |> List.first()
    IO.puts commit["commit"]["committer"]["date"]
  end
end
