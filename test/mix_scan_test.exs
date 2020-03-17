# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.ScanTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Lei.Scan

  describe "run/1" do
    test "run scan, validate report, return report" do
      Scan.run([])
      assert_received {:mix_shell, :info, [report]}

      report_data = Poison.decode!(report)
      assert 10 == report_data["metadata"]["repo_count"]
    end
  end
end
