Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.AnalyzeTest do
  use ExUnit.Case, async: true
  alias Mix.Tasks.Analyze
  describe "run/1" do
    test "run analysis, return report" do
      Analyze.run("https://github.com/kitplummer/xmpp4rails")
      assert_received {:mix_shell, :info, [report]}

      schema_file = File.read!("schema/single_report.schema.json")
      schema = JSON.decode!(schema_file) |> JsonXema.new()

      report_data = JSON.decode!(report)
      assert :ok == JsonXema.validate(schema, report_data)
      assert true == JsonXema.valid?(schema, report_data)
    end
  end
end
