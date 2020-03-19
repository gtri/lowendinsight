# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerTest do
  use ExUnit.Case
  doctest AnalyzerModule

  setup_all do
    {:ok, tmp_path} = Temp.path("lei-analyzer-test")
    {:ok, repo} = GitModule.clone_repo("https://github.com/kitplummer/xmpp4rails", tmp_path)
    {:ok, date} = GitModule.get_last_commit_date(repo)
    GitModule.delete_repo(repo)
    weeks = TimeHelper.get_commit_delta(date) |> TimeHelper.sec_to_weeks()
    [weeks: weeks]
  end

  test "analyze local path repo" do
    {:ok, cwd} = File.cwd()
    {:ok, report} = AnalyzerModule.analyze(["file:///#{cwd}"], "path_test")
    assert "complete" == report[:state]
    repo_data = List.first(report[:report][:repos])
    assert "path_test" == repo_data[:header][:source_client]
    assert %{"mix" => ["#{cwd}/mix.exs", "#{cwd}/mix.lock"]} == repo_data[:data][:project_types]
  end

  test "get empty report" do
    start_time = DateTime.utc_now()
    uuid = UUID.uuid1()
    urls = ["https://github.com/kitplummer/xmpp4rails", "https://github.com/kitplummer/lita-cron"]
    empty_report = AnalyzerModule.create_empty_report(uuid, urls, start_time)

    expected_data = %{
      :metadata => %{
        :times => %{
          :duration => 0,
          :start_time => "",
          :end_time => "start_time"
        }
      },
      :uuid => uuid,
      :state => "incomplete",
      :report => %{
        :repos => urls |> Enum.map(fn url -> %{:data => %{:repo => url}} end)
      }
    }

    assert expected_data[:uuid] == empty_report[:uuid]
    assert expected_data[:report] == empty_report[:report]
    assert expected_data[:start_time] == empty_report[:start_time]
  end

  test "get report", context do
    {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails"], "test")

    expected_data = %{
      :repo => "https://github.com/kitplummer/xmpp4rails",
      :results => %{
        :commit_currency_risk => "critical",
        :commit_currency_weeks => context[:weeks],
        :contributor_count => 1,
        :contributor_risk => "critical",
        :functional_contributor_names => ["Kit Plummer"],
        :functional_contributors => 1,
        :functional_contributors_risk => "critical",
        :large_recent_commit_risk => "low",
        :recent_commit_size_in_percent_of_codebase => 0.00368,
        :top10_contributors => [%{"Kit Plummer" => 7}]
      },
      :project_types => %{},
      :repo_size => "292K",
      :risk => "critical",
      :config => Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight))
    }

    repo_data = List.first(report[:report][:repos])
    assert "test" == repo_data[:header][:source_client]
    assert "https://github.com/kitplummer/xmpp4rails" == repo_data[:header][:repo]
    assert expected_data[:results] == repo_data[:data][:results]
  end

  test "get multi report mixed risks" do
    {:ok, report} =
      AnalyzerModule.analyze(
        ["https://github.com/kitplummer/xmpp4rails", "https://github.com/robbyrussell/oh-my-zsh"],
        "test_multi"
      )

    assert 2 == report[:metadata][:repo_count]
    assert nil == report[:metadata][:risk_counts]["high"]
    assert nil == report[:metadata][:risk_counts]["medium"]
    assert 1 == report[:metadata][:risk_counts]["low"]
    assert 1 == report[:metadata][:risk_counts]["critical"]
  end

  test "get multi report for dot named repo" do
    {:ok, reportx} =
      AnalyzerModule.analyze(["https%3A%2F%2Fgithub.com%2Fsatori%2Fgo.uuid"], "test_dot")

    repo_data = List.first(reportx[:report][:repos])
    assert "test_dot" == repo_data[:header][:source_client]
  end

  test "get multi report mixed risks and bad repo" do
    {:ok, report} =
      AnalyzerModule.analyze(
        ["https://github.com/kitplummer/xmpp4rails", "https://github.com/kitplummer/blah"],
        "test_multi"
      )

    assert 2 == report[:metadata][:repo_count]
  end

  test "input of optional start time" do
    start_time = DateTime.utc_now()

    {:ok, report} =
      AnalyzerModule.analyze(
        ["https://github.com/kitplummer/xmpp4rails"],
        "test_start_time_option",
        start_time
      )

    assert DateTime.to_iso8601(start_time) == report[:metadata][:times][:start_time]
  end

  test "get report fail" do
    {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/blah"], "test")

    expected_data = %{
      data: %{
        error:
          "Unable to analyze the repo (https://github.com/kitplummer/blah), is this a valid Git repo URL?",
        repo: "https://github.com/kitplummer/blah",
        risk: "critical",
        project_types: %{"undetermined" => "undetermined"},
        repo_size: "N/A"
      }
    }

    repo_data = List.first(report[:report][:repos])
    assert expected_data == repo_data
  end

  test "get report fail when subdirectory" do
    {:ok, report} =
      AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails/blah"], "test")

    expected_data = %{
      data: %{
        error:
          "Unable to analyze the repo (https://github.com/kitplummer/xmpp4rails/blah). Not a Git repo URL, is a subdirectory",
        repo: "https://github.com/kitplummer/xmpp4rails/blah",
        risk: "N/A",
        project_types: %{"undetermined" => "undetermined"},
        repo_size: "N/A"
      }
    }

    repo_data = List.first(report[:report][:repos])
    assert expected_data == repo_data
  end

  test "get single repo report validated by report schema" do
    {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/lita-cron"], "test")

    {:ok, report_json} = Poison.encode(report)

    schema_file = File.read!("schema/v1/report.schema.json")
    schema = Poison.decode!(schema_file) |> JsonXema.new()

    report_data = Poison.decode!(report_json)
    assert :ok == JsonXema.validate(schema, report_data)
    assert true == JsonXema.valid?(schema, report_data)
  end

  test "get multi repo report validated by report schema" do
    {:ok, report} =
      AnalyzerModule.analyze(
        ["https://github.com/kitplummer/xmpp4rails", "https://github.com/kitplummer/lita-cron"],
        "test_multi"
      )

    {:ok, report_json} = Poison.encode(report)
    schema_file = File.read!("schema/v1/report.schema.json")
    schema = Poison.decode!(schema_file) |> JsonXema.new()

    report_data = Poison.decode!(report_json)
    assert :ok == JsonXema.validate(schema, report_data)
    assert true == JsonXema.valid?(schema, report_data)
  end
end
