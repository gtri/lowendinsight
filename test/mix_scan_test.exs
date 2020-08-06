# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.ScanTest do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Lei.Scan

  @tag timeout: 130_000
  describe "run/1" do
    test "run scan, validate report, return report" do
      Scan.run([])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 31 == report_data["metadata"]["repo_count"]
      assert 12 == report_data["metadata"]["dependency_count"]
    end
  end

  describe "run/1 with invalid path" do
    test "should fail with valid message" do
      Scan.run(["blah/"])
      assert_received {:mix_shell, :info, [report]}
      assert report == "Invalid path"
    end
  end

  describe "bitbucket based run/1" do
    test "run scan and report against a package that has a known reference to Bitbucket" do
      # Get the repo
      # https://bitbucket.org/npa_io/ueberauth_bitbucket.git
      {:ok, tmp_path} = Temp.path("lei-analyzer-test")

      {:ok, repo} =
        GitModule.clone_repo("https://bitbucket.org/npa_io/ueberauth_bitbucket", tmp_path)

      Scan.run([repo.path])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 16 == report_data["metadata"]["repo_count"]
    end
  end

  describe "multi hub repo scan/1" do
    test "run scan and report against a package that has a known reference to Bitbucket" do
      {:ok, tmp_path} = Temp.path("lei-analyzer-test")

      {:ok, repo} =
        GitModule.clone_repo("https://github.com/kitplummer/mix_test_project", tmp_path)

      Scan.run([repo.path])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 2 == report_data["metadata"]["dependency_count"]
      assert 14 == report_data["metadata"]["repo_count"]
    end
  end

  test "scans package-lock.json" do
    paths = %{node: ["./test/fixtures/packagejson", "./test/fixtures/package-lockjson"]}
    {reports_list, deps_count} = Npm.Scanner.scan(true, paths, "")

    assert 4 == deps_count
    assert 4 == Enum.count(reports_list)
  end

  test "scans first-degree dependencies if package-lock does not exist" do
    path = %{node: ["./test/fixtures/packagejson"]}
    {reports_list, deps_count} = Npm.Scanner.scan(true, path, "")

    assert 4 == deps_count
    assert 4 == Enum.count(reports_list)
  end

  test "scans package.json and yarn.lock" do
    paths = %{node: ["./test/fixtures/packagejson", "./test/fixtures/yarnlock"]}
    {reports_list, deps_count} = Npm.Scanner.scan(true, paths, "")

    assert 4 == deps_count
    assert 3 == Enum.count(reports_list)
  end

  @tag timeout: 140_000
  test "run scan on JS repo, validate report, return report" do
    {:ok, tmp_path} = Temp.path("lei-scan-js-repo-test")
    {:ok, repo} = GitModule.clone_repo("https://github.com/juliangarnier/anime", tmp_path)

    Scan.run([repo.path])
    assert_received {:mix_shell, :info, [report]}

    report_data = Poison.decode!(report)
    assert Map.has_key?(report_data["metadata"], "risk_counts") == true
  end
end