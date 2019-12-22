# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerTest do
  use ExUnit.Case
  doctest AnalyzerModule

  setup_all do
    on_exit(fn ->
      File.rm_rf("xmpp4rails")
      File.rm_rf("lita-cron")
    end)

    File.rm_rf("xmpp4rails")
    File.rm_rf("lita-cron")
    File.rm_rf("go.uuid")

    {:ok, repo} = GitModule.clone_repo("https://github.com/kitplummer/xmpp4rails")
    {:ok, date} = GitModule.get_last_commit_date(repo)
    GitModule.delete_repo(repo)
    weeks = TimeHelper.get_commit_delta(date) |> TimeHelper.sec_to_weeks()
    [weeks: weeks]
  end

  test "get report", context do
    {:ok, report} = AnalyzerModule.analyze("https://github.com/kitplummer/xmpp4rails", "test")
    expected_data = %{
      :commit_currency_risk => "critical",
      :commit_currency_weeks => context[:weeks],
      :contributor_count => 1,
      :contributor_risk => "critical",
      :repo => "https://github.com/kitplummer/xmpp4rails",
      :functional_contributor_names => ["Kit Plummer"],
      :functional_contributors => 1,
      :functional_contributors_risk => "critical",
      :large_recent_commit_risk => "low",
      :recent_commit_size_in_percent_of_codebase => 0.003683241252302026,
      :risk => "critical",
      :config => Application.get_all_env(:lowendinsight)
    }

    assert "test" == report[:header][:source_client]
    assert expected_data == report[:data]
  end

  # test "get multi report" do
  #   {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails",
  #                                            "https://github.com/kitplummer/lita-cron"], 
  #                                          "test_multi")
  #   assert 2 == report[:metadata][:repo_count]
  #   assert nil == report[:metadata][:risk_counts][:high]
  #   assert nil == report[:metadata][:risk_counts][:medium]
  #   assert nil == report[:metadata][:risk_counts][:low]
  #   assert 2 == report[:metadata][:risk_counts]["critical"]
  #   repos = report[:data][:repos]                                        
  #   assert 2 == length(repos)
  #   item_one = Enum.at(repos, 0)
  #   assert "test_multi" == item_one[:header][:source_client]
  # end

  test "get multi report mixed risks" do
    {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails",
                                             "https://github.com/robbyrussell/oh-my-zsh"], 
                                           "test_multi")
    assert 2 == report[:metadata][:repo_count]
    assert nil == report[:metadata][:risk_counts]["high"]
    assert nil == report[:metadata][:risk_counts]["medium"]
    assert 1 == report[:metadata][:risk_counts]["low"]
    assert 1 == report[:metadata][:risk_counts]["critical"]
  end

  test "get multi report for dot named repo" do
    {:ok, reportx} = AnalyzerModule.analyze("https%3A%2F%2Fgithub.com%2Fsatori%2Fgo.uuid", 
                                           "test_dot")
    assert "test_dot" == reportx[:header][:source_client]
  end

  test "get multi report mixed risks and bad repo" do
    {:ok, report} = AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails",
                                             "https://github.com/kitplummer/blah"], 
                                           "test_multi")
    assert 2 == report[:metadata][:repo_count]
  end

  test "get report fail" do
    report = AnalyzerModule.analyze("https://github.com/kitplummer/blah", "test")
    expected_data = {:ok, %{data: %{error: "Unable to analyze the repo (https://github.com/kitplummer/blah), is this a valid Git repo URL?", risk: "critical"}}}

    assert expected_data == report
  end

  test "get report fail when subdirectory" do
    report = AnalyzerModule.analyze("https://github.com/kitplummer/xmpp4rails/blah", "test")
    expected_data = {:ok, %{data: %{error: "Unable to analyze the repo (https://github.com/kitplummer/xmpp4rails/blah). Not a Git repo URL, is a subdirectory", risk: "N/A"}}}

    assert expected_data == report
  end
end
