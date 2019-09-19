defmodule AnalyzerModule do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """

  def analyze(url) do
    {:ok, repo} = Git.clone url

    # Get unique contributors count
    {:ok, count} = GitModule.get_contributor_count(repo)

    # Get risk rating for count
    {:ok, count_risk} = RiskLogic.contributor_risk(count)

    # Get last commit in weeks
    {:ok, date} = GitModule.get_last_commit_date(repo)
    weeks = TimeHelper.get_commit_delta(date) |> TimeHelper.sec_to_weeks

    # Get risk rating for last commit
    {:ok, delta_risk} = RiskLogic.commit_currency_risk(weeks)

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

    elem(JSON.encode(report), 1)
  end
end
