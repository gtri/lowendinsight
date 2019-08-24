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
        Git.shortlog!(repo, ["-s", "-n", "HEAD"])
          |> String.trim()
          |> String.split(~r{\s\s+})
          |> Enum.count()
      {:error, _error} ->
        {:error, "Repository not found"}
    end
  end

end
