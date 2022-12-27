# Copyright (C) 2022 by Kit Plummer
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule FilesTest do
  use ExUnit.Case, async:  false
  doctest Lowendinsight.Files
  # setup_all do
  #   {:ok, tmp_path} = Temp.path("lei-analyzer-test")
  #   {:ok, repo} = GitModule.clone_repo("https://github.com/kitplummer/xmpp4rails", tmp_path)
  #   {:ok, date} = GitModule.get_last_commit_date(repo)
  #   GitModule.delete_repo(repo)
  #   weeks = TimeHelper.get_commit_delta(date) |> TimeHelper.sec_to_weeks()
  #   [weeks: weeks]
  # end
  test "analyze files in path repo" do
    {:ok, report} =
      AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails"], "files_path_test", DateTime.utc_now(), %{types: false})

    assert "complete" == report[:state]
    repo_data = List.first(report[:report][:repos])
    assert "files_path_test" == repo_data[:header][:source_client]
    assert %{binary_files: [],
             binary_files_count: 0,
             total_file_count: 15,
             has_readme: true,
             has_license: true,
             has_contributing: false} == repo_data[:data][:files]
  end

  test "analyze files in elixir repo" do
    {:ok, report} =
      AnalyzerModule.analyze(["https://github.com/gtri/lowendinsight"], "files_path_test", DateTime.utc_now(), %{types: false})

    assert "complete" == report[:state]
    repo_data = List.first(report[:report][:repos])
    assert "files_path_test" == repo_data[:header][:source_client]
    assert %{binary_files: ["lei_bus_128.png"],
             binary_files_count: 2,
             total_file_count: 176,
             has_readme: true,
             has_license: true,
             has_contributing: false} == repo_data[:data][:files]
  end
end
