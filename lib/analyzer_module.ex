# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerModule do
  @moduledoc """
  Analyzer takes in a valid repo URL and coordinates the analysis,
  returning a simple JSON report.  The URL can be one of "https", "http",
  or "file".  Note, that the latter scheme will only work an existing clone
  and won't remove the directory structure upon completion of analysis.
  """
  require Logger

  @spec analyze(binary | maybe_improper_list, any, any) :: {:ok, map}
  def analyze(url, source, options) when is_binary(url) do
    count =
      if Map.has_key?(options, :counter) do
        CounterAgent.click(options[:counter])
        CounterAgent.get(options[:counter])
      end

    Temp.track!()

    start_time = DateTime.utc_now()

    # Return summary report as JSON
    # Workaround to allow `mix analyze` to work even that :application doesn't exist
    library_version =
      if :application.get_application() != :undefined,
        do: elem(:application.get_key(:lowendinsight, :vsn), 1) |> List.to_string(),
        else: ""

    try do
      url = URI.decode(url)

      # Prevent a clone if configuration isn't found, forces an ArgumentError
      # "could not fetch application environment :critical_contributor_level
      #  for application :lowendinsight because the application was not loaded/started.
      #  If your application depends on :lowendinsight at runtime, make sure to
      #  load/start it or list it under :extra_applications in your mix.exs file"
      # _config = Application.fetch_env!(:lowendinsight, :critical_contributor_level)

      uri = URI.parse(url)

      {:ok, repo} =
        cond do
          uri.scheme == "file" ->
            GitModule.get_repo(uri.path)

          uri.scheme == "https" or uri.scheme == "http" or uri.scheme == "git+https" ->

            url =
              if uri.scheme == "git+https" do
                String.slice(url, 4..-1)
              else
                url
              end

            if Helpers.count_forward_slashes(url) > 4 do
              Logger.error("Not a Git repo URL, is a subdirectory")
              raise ArgumentError, message: "Not a Git repo URL, is a subdirectory"
            end

            tmp =
              Temp.mkdir(%{
                prefix: "lei",
                basedir: Application.fetch_env!(:lowendinsight, :base_temp_dir) || "/tmp"
              })

            tmp_path =
              case tmp do
                {:ok, tmp_path} ->
                  tmp_path

                {:error, :enoent} ->
                  raise ArgumentError, message: "Failed to create a temp path for clone"
              end

            GitModule.clone_repo(url, tmp_path)

          true -> 
            # raise ArgumentError, message: "Not a public Git repo URL"
            {:ok}
        end

      Logger.info("Cloned -> #{count}: #{url}")

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

      ## Non-metric data about repo
      mix_type = %ProjectType{name: :mix, path: "", files: ["mix.exs,mix.lock"]}

      python_type = %ProjectType{
        name: :python,
        path: "**",
        files: ["setup.py,*requirements.txt*"]
      }

      node_type = %ProjectType{name: :node, path: "**", files: ["package*.json"]}
      go_type = %ProjectType{name: :go_mod, path: "**", files: ["go.mod"]}
      cargo_type = %ProjectType{name: :cargo, path: "**", files: ["Cargo.toml"]}
      rubygem_type = %ProjectType{name: :rubygem, path: "**", files: ["Gemfile*,*.gemspec"]}
      maven_type = %ProjectType{name: :maven, path: "**", files: ["pom.xml"]}
      gradle_type = %ProjectType{name: :gradle, path: "**", files: ["build.gradle*"]}

      project_types = [
        mix_type,
        python_type,
        node_type,
        go_type,
        cargo_type,
        rubygem_type,
        maven_type,
        gradle_type
      ]

      project_types_identified =
        case Map.has_key?(options, :types) && options.types == true do
          true ->
            ProjectIdent.categorize_repo(repo, project_types) |> Helpers.convert_config_to_list()

          false ->
            []
        end

      {:ok, repo_size} = GitModule.get_repo_size(repo)
      {:ok, git_hash} = GitModule.get_hash(repo)
      {:ok, default_branch} = GitModule.get_default_branch(repo)

      if uri.scheme == "https" or uri.scheme == "http" do
        GitModule.delete_repo(repo)
      end

      end_time = DateTime.utc_now()
      duration = DateTime.diff(end_time, start_time)

      config =
        if Application.get_all_env(:lowendinsight) == [],
          do: %{info: "no config loaded, defaults in use"},
          else: Application.get_all_env(:lowendinsight)

      report = %{
        header: %{
          repo: url,
          start_time: DateTime.to_iso8601(start_time),
          end_time: DateTime.to_iso8601(end_time),
          duration: duration,
          uuid: UUID.uuid1(),
          source_client: source,
          library_version: library_version
        },
        data: %{
          config: Helpers.convert_config_to_list(config),
          repo: url,
          git: %{
            hash: git_hash,
            default_branch: default_branch
          },
          project_types: project_types_identified,
          repo_size: repo_size,
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

      Temp.cleanup()
      {:ok, determine_toplevel_risk(report)}
    rescue
      MatchError ->
        end_time = DateTime.utc_now()
        duration = DateTime.diff(end_time, start_time)
        {:ok, %{
           header: %{
            repo: url,
            start_time: DateTime.to_iso8601(start_time),
            end_time: DateTime.to_iso8601(end_time),
            duration: duration,
            uuid: UUID.uuid1(),
            source_client: source,
            library_version: library_version
          },
           data: %{
             # config: Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight)),
             error: "Unable to analyze the repo (#{url}), is this a valid Git repo URL?",
             repo: url,
             git: %{},
             risk: "critical",
             project_types: %{"undetermined" => "undetermined"},
             repo_size: "N/A"
           }
         }}

      e in ArgumentError ->
        end_time = DateTime.utc_now()
        duration = DateTime.diff(end_time, start_time)
        {:ok, %{
          header: %{
            repo: url,
            start_time: DateTime.to_iso8601(start_time),
            end_time: DateTime.to_iso8601(end_time),
            duration: duration,
            uuid: UUID.uuid1(),
            source_client: source,
            library_version: library_version
          },
           data: %{
             # config: Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight)),
             error: "Unable to analyze the repo (#{url}). #{e.message}",
             repo: url,
             git: %{},
             risk: "N/A",
             project_types: %{"undetermined" => "undetermined"},
             repo_size: "N/A"
           }
         }}
    after
      Temp.cleanup()
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
  @spec analyze([binary], any, any, any) :: {:ok, map}
  def analyze(urls, source \\ "lei", start_time \\ DateTime.utc_now(), options \\ %{})
      when is_list(urls) do
    ## Concurrency for parallelizing the analysis. This is the magic.
    ## Will run two jobs per core available max...

    {:ok, counter} = CounterAgent.new()
    options = Map.put(options, :counter, counter)

    max_concurrency =
      System.schedulers_online() *
        (Application.get_env(:lowendinsight, :jobs_per_core_max) || 1)

    l =
      urls
      |> Task.async_stream(__MODULE__, :analyze, [source, options],
        timeout: :infinity,
        max_concurrency: max_concurrency
      )
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
  @spec create_empty_report(String.t, [String.t], any) :: map
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
  both the atom and string elements, because the JSON gets parsed into the string
  format - so caching can be supported (as reports are stored in JSON).
  """
  @spec determine_risk_counts(RepoReport.t) :: map
  def determine_risk_counts(report) do
    count_map =
      report[:report][:repos]
      |> Enum.map(fn repo -> repo.data.risk end)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    metadata = Map.put_new(report[:metadata], :risk_counts, count_map)
    report |> Map.put(:metadata, metadata)
  end

  @doc """
  determine_toplevel_risk/1: takes in a report and determines the highest
  criticality, and assigns it to the "risk" element for the repo report.
  """
  @spec determine_toplevel_risk(RepoReport.t) :: map
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
