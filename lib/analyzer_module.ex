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

    # Get risk rating for size of last commit

    {:ok, lines_percent, _file_percent} = GitModule.get_recent_changes(repo)
    {:ok, changes_risk} = RiskLogic.commit_change_size_risk(lines_percent)

    {:ok, num_filtered_contributors} = GitModule.get_num_filtered_contributors(repo)
    {:ok, filtered_contributors_risk} = RiskLogic.functional_contributors_risk(num_filtered_contributors)


    # Generate report

    # Delete repo source
    GitModule.delete_repo(repo)

    # Return summary report as JSON
    report = [repo: url,
              contributor_count: count,
              contributor_risk: count_risk,
              commit_currency_weeks: weeks,
              commit_currency_risk: delta_risk,
              recent_commit_size_risk: changes_risk,
              functional_contributors: filtered_contributors_risk
    ]

    elem(JSON.encode(report), 1)
  end
end
