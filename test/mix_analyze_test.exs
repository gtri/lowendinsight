# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.AnalyzeTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Analyze
  describe "run/1" do
    test "run analysis, validate report, return report" do
      Analyze.run(["https://github.com/kitplummer/xmpp4rails"])
      assert_received {:mix_shell, :info, [report]}

      schema = File.read!("schema/v1/multi_report.schema.json")
      |> JSON.decode!() 
      |> JsonXema.new()

      report_data = JSON.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)

      Analyze.run(["https://github.com/kitplummer/blah"])
      assert_received {:mix_shell, :info, [report]}

      report_data = JSON.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)
    end
  end
end
