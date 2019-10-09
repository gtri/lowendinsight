defmodule AnalyzerModule do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """

  def analyze(url, source) do
    start_time = DateTime.utc_now()

    try do
      {:ok, repo} = GitModule.clone_repo url

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

      # get risk rating for number of contributors with over a certain percentage of commits

      {:ok, num_filtered_contributors, functional_contributors} = GitModule.get_functional_contributors(repo)
      {:ok, filtered_contributors_risk} = RiskLogic.functional_contributors_risk(num_filtered_contributors)

      GitModule.delete_repo(repo)

      # Generate report

      end_time = DateTime.utc_now()
      duration = DateTime.diff(end_time, start_time)
      # Return summary report as JSON
      report = [header: [
                  start_time: DateTime.to_string(start_time),
                  end_time: DateTime.to_string(end_time),
                  duration: duration,
                  uuid: UUID.uuid1(),
                  source_client: source
                ],
                data: [
                  repo: url,
                  contributor_count: count,
                  contributor_risk: count_risk,
                  commit_currency_weeks: weeks,
                  commit_currency_risk: delta_risk,
                  large_recent_commit_risk: changes_risk,
                  recent_commit_size_in_percent_of_codebase: lines_percent,
                  functional_contributors_risk: filtered_contributors_risk,
                  functional_contributors: num_filtered_contributors,
                  functional_contributor_names: functional_contributors
                ]
      ]

      elem(JSON.encode(report), 1)

    rescue

      MatchError -> resp = [header: [
                  uuid: UUID.uuid1(),
                  source_client: source
                ],
                data: [
                  error: "Repo error!"
                ]
      ]

      elem(JSON.encode(resp), 1)
      #e in MatchError -> IO.puts("Repo error! " <> e[:term])
    
    end

  end
end
