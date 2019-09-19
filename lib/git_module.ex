defmodule GitModule do

  @moduledoc """
  Documentation for the GitModule.
  """

  @doc """
  clone/1: clones the repo
  """

  def clone_repo(url) do
    response = Git.clone url
    case response do
      {:ok, repo} ->
        {:ok, repo}
      {:error, _error} ->
        {:error, "Repository not found"}
    end
  end

  @doc """
  get_contributors_count/1: returns the number of contributors for
  a given Git repo
  """

  def get_contributor_count(repo) do
    count = Git.shortlog!(repo, ["-s", "-n", "HEAD"])
      |> String.trim()
      |> String.split(~r{\s\s+})
      |> Enum.count()
    {:ok, count}
  end

  @doc """
  get_last_commit_date/1: returns the date of the last commit
  """

  def get_last_commit_date(repo) do
    date = Git.log!(repo, ["-1", "--pretty=format:%cI"])
    {:ok, date}
  end

  def delete_repo(repo) do
    {:ok, slug} = Helpers.get_slug(repo.path)
    {:ok, _org, proj} = Helpers.split_slug(slug)
    File.rm_rf proj
    :ok
  end

end
