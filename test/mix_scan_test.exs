# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.ScanTest do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Lei.Scan

  describe "run/1" do
    test "run scan, validate report, return report" do
      Scan.run([])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 29 == report_data["metadata"]["repo_count"]
      assert 10 == report_data["metadata"]["dependency_count"]
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
end
