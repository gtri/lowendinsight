# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.AnalyzeTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Lei.Analyze
  @tag :long
  describe "run/1" do
    test "run analysis, validate report, return report" do
      Analyze.run(["https://github.com/expressjs/express"])
      assert_received {:mix_shell, :info, [report]}

      schema =
        File.read!("schema/v1/report.schema.json")
        |> Poison.decode!()
        |> JsonXema.new()

      report_data = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)

      repo_data = List.first(report_data["report"]["repos"])
      assert repo_data["data"]["project_types"] != nil

      Analyze.run(["https://github.com/kitplummer/blah"])
      assert_received {:mix_shell, :info, [report]}
      report_data = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)

      Analyze.run(["https://github.com/amorphid/artifactory-elixir"])
      assert_received {:mix_shell, :info, [report]}
      report_data = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)

      Analyze.run(["https://github.com/wli0503/Mixeur"])
      assert_received {:mix_shell, :info, [report]}
      report_data = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)

      Analyze.run(["https://github.com/betesy/201601betesy_test.git"])
      assert_received {:mix_shell, :info, [report]}
      report_data1 = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data1)
      assert true == JsonXema.valid?(schema, report_data1)

      Analyze.run(["https://gitlab.com/lowendinsight/test/pymodule"])
      assert_received {:mix_shell, :info, [report]}
      report_data = Poison.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
    end
  end
end
