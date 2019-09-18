defmodule Analyzer do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """

  def analyse(url) do
    {:ok, repo} = Git.clone url

    # Get unique contributors count
    {:ok, count} = GitModule.get_contributor_count(repo)
    # Get risk rating for count

    # Get last commit in weeks

    # Get risk rating for last commit

    # Generate report

    # Delete repo source

    # Return summary report as JSON
    report = {}
    {:ok, report}
  end
end
