# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerModule do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """
  @spec analyze(String.t() | list(), String.t()) :: tuple()
  def analyze(url, source) when is_binary(url) do
    start_time = DateTime.utc_now()

    try do
      url = URI.decode(url)

      # Prevent a clone if configuration isn't found, forces an ArgumentError
      # "could not fetch application environment :critical_contributor_level
      #  for application :lowendinsight because the application was not loaded/started.
      #  If your application depends on :lowendinsight at runtime, make sure to
      #  load/start it or list it under :extra_applications in your mix.exs file"
      _config = Application.fetch_env!(:lowendinsight, :critical_contributor_level)

      if Helpers.count_forward_slashes(url) > 4 do
        raise ArgumentError, message: "Not a Git repo URL, is a subdirectory"
      end

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

      {:ok, top10_contributors} = GitModule.get_top10_contributors_map(repo)

      GitModule.delete_repo(repo)

      # Generate report
      end_time = DateTime.utc_now()
      duration = DateTime.diff(end_time, start_time)

      # Return summary report as JSON
      # Workaround to allow `mix analyze` to work even that :application doesn't exist
      library_version =
        if :application.get_application() != :undefined,
          do: elem(:application.get_key(:lowendinsight, :vsn), 1) |> List.to_string(),
          else: ""

      report = %{
        header: %{
          start_time: DateTime.to_iso8601(start_time),
          end_time: DateTime.to_iso8601(end_time),
          duration: duration,
          uuid: UUID.uuid1(),
          source_client: source,
          library_version: library_version
        },
        data: %{
          config: Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight)),
          repo: url,
          results: %{
            contributor_count: count,
            contributor_risk: count_risk,
            commit_currency_weeks: weeks,
            commit_currency_risk: delta_risk,
            large_recent_commit_risk: changes_risk,
            recent_commit_size_in_percent_of_codebase: lines_percent,
            functional_contributors_risk: filtered_contributors_risk,
            functional_contributors: num_filtered_contributors,
            functional_contributor_names: functional_contributors,
            top10_contributors: top10_contributors
          }
        }
      }

      {:ok, determine_toplevel_risk(report)}
    rescue
      MatchError ->
        {:ok,
         %{
           data: %{
             config: Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight)),
             error: "Unable to analyze the repo (#{url}), is this a valid Git repo URL?",
             repo: url,
             risk: "critical"
           }
         }}

      e in ArgumentError ->
        {:ok,
         %{
           data: %{
             config: Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight)),
             error: "Unable to analyze the repo (#{url}). #{e.message}",
             repo: url,
             risk: "N/A"
           }
         }}
    end
  end

  @doc """
  analyze/3: returns the LowEndInsight report as JSON for multiple_repos.  Takes in a "list" of
  urls, a source id for the calling client, and the start_time of analysis as an optional way
  to capture the time actually started at whatever the client is (e.g. an async API).

  Returns Map.

  ## Examples
    ```
    iex> {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails","https://github.com/kitplummer/lita-cron"], "iex")
    iex> _count = report[:metadata][:repo_count]
    2
    ```
  """
  # @defaults %{start_time: DateTime.utc_now()}
  def analyze(urls, source, start_time \\ DateTime.utc_now()) when is_list(urls) do
    # %{start_time: start_time} = Enum.into(opts, @defaults)
    ## Concurrency for parallelizing the analysis.  Turn the analyze/2 function into a worker.
    l =
      urls
      |> Task.async_stream(__MODULE__, :analyze, [source], timeout: :infinity, max_concurrency: 10)
      |> Enum.map(fn {:ok, report} -> elem(report, 1) end)

    report = %{
      state: "complete",
      report: %{uuid: UUID.uuid1(), repos: l},
      metadata: %{repo_count: length(l)}
    }

    report = determine_risk_counts(report)
    end_time = DateTime.utc_now()
    duration = DateTime.diff(end_time, start_time)

    times = %{
      start_time: DateTime.to_iso8601(start_time),
      end_time: DateTime.to_iso8601(end_time),
      duration: duration
    }

    metadata = Map.put_new(report[:metadata], :times, times)
    report = report |> Map.put(:metadata, metadata)
    {:ok, report}
  end

  @doc """
  create_empty_report/3: takes in a uuid, list of urls, and a start time and 
  produces the repo report object to be returned immediately by asynchronous
  requestors (e.g. LowEndInsight-Get HTTP endpoint)
  """
  def create_empty_report(uuid, urls, start_time \\ DateTime.utc_now()) do
    %{
      :metadata => %{
        :times => %{
          :duration => 0,
          :start_time => DateTime.to_iso8601(start_time),
          :end_time => ""
        }
      },
      :uuid => uuid,
      :state => "incomplete",
      :report => %{
        :repos => urls |> Enum.map(fn url -> %{:data => %{:repo => url}} end)
      }
    }
  end

  @doc """
  determine_risk_counts/1: takes in a full report of n-repo reports, and calculates
  the number or risk ratings, given the number of repos.  It returns a new report
  with the risk_counts object populated with the count table.  Have to accommodate
  both the atom and string elements, becuse the JSON gets parsed into the string
  format - so caching can be supported (as reports are stored in JSON).
  """
  def determine_risk_counts(report) do
    count_map =
      report[:report][:repos]
      |> Enum.map(fn repo -> repo[:data][:risk] end)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    metadata = Map.put_new(report[:metadata], :risk_counts, count_map)
    report |> Map.put(:metadata, metadata)
  end

  @doc """
  determine_toplevel_risk/1: takes in a report and determines the highest
  criticality, and assigns it to the "risk" element for the repo report.
  """
  def determine_toplevel_risk(report) do
    values = Map.values(report[:data][:results])

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
