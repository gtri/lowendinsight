# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ScannerModule do
  @moduledoc """
  Scanner scans.
  """

  def dependencies(path) do
    cwd = File.cwd!()

    File.cd!(path)

    deps =
      File.read!("./mix.lock")
      |> Hex.Lockfile.parse!(true)
      |> Hex.Encoder.lockfile_json()

    File.cd!(cwd)
    deps
  end

  def scan(path) do
    cwd = File.cwd!()

    File.cd!(path)
    start_time = DateTime.utc_now()

    project_types_identified = ProjectIdent.get_project_types_identified(path)

    mix? = Map.has_key?(project_types_identified, :mix)
    node? = Map.has_key?(project_types_identified, :node)

    {hex_reports_list, hex_deps_count} = Hex.Scanner.scan(mix?, project_types_identified)
    {npm_reports_list, npm_deps_count} = Npm.Scanner.scan(node?, project_types_identified)

    result_list = hex_reports_list ++ npm_reports_list

    if !Enum.empty?(result_list) do
      result = %{
        :state => :complete,
        :metadata => %{
          repo_count: Enum.count(result_list),
          dependency_count: hex_deps_count + npm_deps_count
        },
        :report => %{:uuid => UUID.uuid1(), :repos => result_list}
      }

      result = AnalyzerModule.determine_risk_counts(result)

      end_time = DateTime.utc_now()
      duration = DateTime.diff(end_time, start_time)

      times = %{
        start_time: DateTime.to_iso8601(start_time),
        end_time: DateTime.to_iso8601(end_time),
        duration: duration
      }

      metadata = Map.put_new(result[:metadata], :times, times)
      result = result |> Map.put(:metadata, metadata)

      File.cd!(cwd)

      Poison.encode!(result, pretty: true)
      # Encoder.mixfile_json(mixfile)
    else
      Poison.encode!(%{:error => "No mix or npm dependency files were found"}, pretty: true)
    end
  end
end
