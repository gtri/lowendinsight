# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerModule do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """

  @doc """
  analyze/2: returns the LowEndInsight report as JSON

  Returns Map.

  ## Examples
    ```
    iex> {:ok, report} = AnalyzerModule.analyze("https://github.com/kitplummer/xmpp4rails", "iex")
    iex> _risk = report[:data][:risk]
    "critical"
    ```
  """
  def analyze(url, source) do
    start_time = DateTime.utc_now()

    try do
      {:ok, repo} = GitModule.clone_repo(url)

      # Get unique contributors count
      {:ok, count} = GitModule.get_contributor_count(repo)

      # Get risk rating for count
      {:ok, count_risk} = RiskLogic.contributor_risk(count)

      # Get last commit in weeks
      {:ok, date} = GitModule.get_last_commit_date(repo)
      weeks = TimeHelper.get_commit_delta(date) |> TimeHelper.sec_to_weeks()

      # Get risk rating for last commit
      {:ok, delta_risk} = RiskLogic.commit_currency_risk(weeks)

      # Get risk rating for size of last commit

      {:ok, lines_percent, _file_percent} = GitModule.get_recent_changes(repo)
      {:ok, changes_risk} = RiskLogic.commit_change_size_risk(lines_percent)

      # get risk rating for number of contributors with over a certain percentage of commits

      {:ok, num_filtered_contributors, functional_contributors} =
        GitModule.get_functional_contributors(repo)

      {:ok, filtered_contributors_risk} =
        RiskLogic.functional_contributors_risk(num_filtered_contributors)

      GitModule.delete_repo(repo)

      # Generate report

      end_time = DateTime.utc_now()
      duration = DateTime.diff(end_time, start_time)
      # Return summary report as JSON
      report = %{
        header: %{
          start_time: DateTime.to_string(start_time),
          end_time: DateTime.to_string(end_time),
          duration: duration,
          uuid: UUID.uuid1(),
          source_client: source
        },
        data: %{
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
        }
      }

      {:ok, determine_toplevel_risk(report)}

      #elem(JSON.encode(report), 1)
    rescue
      MatchError ->
        resp = [
          error:
            "this is a POSTful service, JSON body with valid git url param required and content-type set to application/json."
        ]

        elem(JSON.encode(resp), 1)
        # e in MatchError -> IO.puts("Repo error! " <> e[:term])
    end
  end

  defp determine_toplevel_risk(report) do
    values = Map.values(report[:data])

    risk =
      cond do
        Enum.member?(values, "critical") -> "critical"
        Enum.member?(values, "high") -> "high"
        Enum.member?(values, "medium") -> "medium"
        true -> "low"
      end

    data = report[:data]
    data = Map.put_new(data, :risk, risk)
    report |> Map.put(:header, report[:header]) |> Map.put(:data, data)
  end
end
