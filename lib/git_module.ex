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

    {:ok, repo} = Git.clone url
    list = Git.shortlog!(repo, ["-s", "-n", "HEAD"])
    list = String.trim(list)
    list = String.split(list, ~r{\s\s+})
    Enum.count(list)
  end

end
