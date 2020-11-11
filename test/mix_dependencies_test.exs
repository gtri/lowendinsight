# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.DependenciesTest do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Lei.Dependencies

  describe "run/1 with invalid path" do
    test "should fail with valid message" do
      Dependencies.run(["blah/"])
      assert_received {:mix_shell, :info, [report]}
      assert report == "Invalid path"
    end
  end

  describe "test dependencies report" do
    test "run scan and report against no args local" do
      Dependencies.run([])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      bunt = List.first(report_data)

      assert "bunt" == bunt["name"]
    end

    test "run scan and report against given local" do
      Dependencies.run(["."])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      bunt = List.first(report_data)

      assert "bunt" == bunt["name"]
    end
  end
end
