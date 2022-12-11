# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.ScanTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Lei.Scan

  @tag timeout: 130_000
  @tag :long
  describe "run/1" do
    test "run scan, validate report, return report" do
      Scan.run([])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 34 == report_data["metadata"]["repo_count"]
      assert 14 == report_data["metadata"]["dependency_count"]
    end
  end

  @tag :long
  describe "run/1 with invalid path" do
    test "should fail with valid message" do
      Scan.run(["blah/"])
      assert_received {:mix_shell, :info, [report]}
      assert report == "Invalid path"
    end
  end

  @tag timeout: 130_000
  @tag :long
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
    @tag :long
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

  @moduletag timeout: 200000
  @tag :long
  test "run scan against package-lock.json" do
    paths = %{node: ["./test/fixtures/packagejson", "./test/fixtures/package-lockjson"]}
    {reports_list, [], deps_count} = Npm.Scanner.scan(true, paths, "")

    assert 1 == deps_count
    assert 1 == Enum.count(reports_list)
  end

  @tag :long
  test "run scan against first-degree dependencies if package-lock does not exist" do
    path = %{node: ["./test/fixtures/packagejson"]}
    {reports_list, [], deps_count} = Npm.Scanner.scan(true, path, "")

    assert 1 == deps_count
    assert 1 == Enum.count(reports_list)
  end

  @tag :long
  test "run scan against package.json and yarn.lock" do
    paths = %{node: ["./test/fixtures/packagejson", "./test/fixtures/yarnlock"]}
    {[], reports_list, deps_count} = Npm.Scanner.scan(true, paths, "")

    assert 1 == deps_count
    assert 1 == Enum.count(reports_list)
  end

  @moduletag timeout: 200000
  @tag :long
  test "run scan against package.json, package-lock.json and yarn.lock" do
    paths = %{
      node: [
        "./test/fixtures/packagejson",
        "./test/fixtures/package-lockjson",
        "./test/fixtures/yarnlock"
      ]
    }

    {json_reports_list, yarn_reports_list, deps_count} = Npm.Scanner.scan(true, paths, "")

    assert 1 == deps_count
    assert 1 == Enum.count(json_reports_list)
    assert 1 == Enum.count(yarn_reports_list)
  end

  @tag timeout: 140_000
  @tag :long
  test "run scan on JS repo, validate report, return report" do
    {:ok, tmp_path} = Temp.path("lei-scan-js-repo-test")
    {:ok, repo} = GitModule.clone_repo("https://github.com/juliangarnier/anime", tmp_path)

    Scan.run([repo.path])
    assert_received {:mix_shell, :info, [report]}

    report_data = Poison.decode!(report)
    assert Map.has_key?(report_data["metadata"], "risk_counts") == true
  end

  @moduletag timeout: 200000
  @tag :long
  test "return 2 reports for package-lock.json and yarn.lock" do
    paths = [
      "./test/fixtures/packagejson",
      "./test/fixtures/yarnlock",
      "./test/fixtures/package-lockjson"
    ]

    {json_reports_list, yarn_reports_list, deps_count} =
      Npm.Scanner.scan(true, %{node: paths}, "")

    project_types = [:node]

    report =
      ScannerModule.get_report(
        DateTime.utc_now(),
        deps_count,
        [hex: [], node_json: json_reports_list, node_yarn: yarn_reports_list, pypi: []],
        project_types
      )

    assert report[:metadata][:files] == project_types
    assert report[:scan_node_json] != nil && report[:scan_node_yarn] != nil
    assert report[:scan_node_json][:metadata][:dependency_count] == deps_count
  end

  @tag :long
  test "run scan against requirements.txt" do
    paths = %{python: ["./test/fixtures/requirementstxt"]}
    {requirements_reports_list, deps_count} = Pypi.Scanner.scan(true, paths, "")

    assert 2 == deps_count
    assert 2 == Enum.count(requirements_reports_list)
    [furl_report | [quokka_report | _]] = requirements_reports_list

    assert furl_report[:data][:risk] != nil
    assert quokka_report[:data][:risk] != nil
  end

  @tag :long
  test "run scan on python repo, validate report, return report" do
    {:ok, tmp_path} = Temp.path("lei-scan-python-repo-test")
    {:ok, repo} = GitModule.clone_repo("https://github.com/kitplummer/clikan", tmp_path)

    Scan.run([repo.path])
    assert_received {:mix_shell, :info, [report]}

    report_data = Poison.decode!(report)
    assert Map.has_key?(report_data["metadata"], "risk_counts") == true
  end
end
