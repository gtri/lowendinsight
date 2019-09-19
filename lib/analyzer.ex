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
    {:ok, count_risk} = Risk_Logic.contributor_risk(count)

    # Get last commit in weeks
    {:ok, weeks} = GitModule.get_last_commit_date(repo)
    |> TimeHelper.get_commit_delta

    # Get risk rating for last commit
    {:ok, delta_risk} = Risk_Logic.commit_currency_risk(weeks)

    # Generate report

    # Delete repo source

    GitModule.delete_repo(repo)

    # Return summary report as JSON
    report = [repo: url,
              contributor_count: count,
              contributor_risk: count_risk,
              commit_currency_weeks: weeks,
              commit_currency_risk: delta_risk
    ]

    {:ok, JSON.encode(report)}
  end
end
