defmodule GitModule do

  @moduledoc """
  Documentation for the GitModule.
  """

  @doc """
  get_contributors_count/1: returns the number of contributors for
  a given Git repo
  """

  def get_contributor_count(url) do
    # Get run some commands to clone the repo
    # Then get the count of contributors

    response = Git.clone url
    case response do
      {:ok, repo} ->
        count = Git.shortlog!(repo, ["-s", "-n", "HEAD"])
          |> String.trim()
          |> String.split(~r{\s\s+})
          |> Enum.count()
        delete_repo(repo)
        {:ok, count}
      {:error, _error} ->
        {:error, "Repository not found"}
    end
  end

  def get_last_commit_date(url) do
    response = Git.clone url
    case response do
      {:ok, repo} ->
        date = Git.log!(repo, ["-1", "--pretty=format:%cI"])
        delete_repo(repo)
        {:ok, date}
      {:error, _error} ->
        {:error, "Repository not found"}
    end
  end

  def delete_repo(repo) do
    {:ok, slug} = Helpers.get_slug(repo.path)
    {:ok, _org, proj} = Helpers.split_slug(slug)
    File.rm_rf proj
    :ok
  end

end
