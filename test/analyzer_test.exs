# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule AnalyzerTest do
  use ExUnit.Case
  doctest AnalyzerModule

  setup_all do
    on_exit(fn ->
      File.rm_rf("xmpp4rails")
    end)

    File.rm_rf("xmpp4rails")

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
      :risk => "critical"
    }

    assert "test" == report[:header][:source_client]
    assert expected_data == report[:data]
  end

  test "get report fail" do
    report = AnalyzerModule.analyze("https://github.com/kitplummer/blah", "test")
    expected_data = {:error, "Unable to analyze the repo (https://github.com/kitplummer/blah)."}

    assert expected_data == report
  end
end
