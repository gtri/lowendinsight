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
    pypi? = Map.has_key?(project_types_identified, :python)

    {hex_reports_list, hex_deps_count} = Hex.Scanner.scan(mix?, project_types_identified)

    {json_reports_list, yarn_reports_list, npm_deps_count} =
      Npm.Scanner.scan(node?, project_types_identified)

    {pypi_reports_list, pypi_deps_count} = Pypi.Scanner.scan(pypi?, project_types_identified)

    reports = [
      hex: hex_reports_list,
      node_json: json_reports_list,
      node_yarn: yarn_reports_list,
      pypi: pypi_reports_list
    ]

    result =
      get_report(
        start_time,
        hex_deps_count + npm_deps_count + pypi_deps_count,
        reports,
        project_types_identified
      )

    File.cd!(cwd)

    Poison.encode!(result, pretty: true)
  end

  def get_report(
        start_time,
        deps_count,
        [hex: hex_report, node_json: json_report, node_yarn: yarn_report, pypi: pypi_report] = reports,
        project_types
      ) do
    files =
      Enum.map(reports, fn {k, v} -> if !Enum.empty?(v), do: k end)
      |> Enum.reject(fn k -> k == nil end)

    cond do
      # If both package-lock.json and yarn.lock are present, create 2 separate reports
      Enum.member?(files, :node_json) && Enum.member?(files, :node_yarn) ->
        # json
        result_json_list = hex_report ++ json_report
        result_yarn_list = hex_report ++ yarn_report

        result_json = %{
          :state => :complete,
          :metadata => %{
            repo_count: Enum.count(result_json_list),
            dependency_count: deps_count
          },
          :report => %{
            :uuid => UUID.uuid1(),
            :repos => result_json_list
          }
        }

        result_yarn = %{
          :state => :complete,
          :metadata => %{
            repo_count: Enum.count(result_yarn_list),
            dependency_count: deps_count
          },
          :report => %{
            :uuid => UUID.uuid1(),
            :repos => result_yarn_list
          }
        }

        result_json = AnalyzerModule.determine_risk_counts(result_json)
        result_yarn = AnalyzerModule.determine_risk_counts(result_yarn)

        end_time = DateTime.utc_now()

        result = %{
          :scan_node_json => result_json,
          :scan_node_yarn => result_yarn,
          :metadata => %{
            :times => %{
              start_time: DateTime.to_iso8601(start_time),
              end_time: DateTime.to_iso8601(end_time),
              duration: DateTime.diff(end_time, start_time)
            },
            :files => project_types
          }
        }

        result |> Map.put(:scan_node_yarn, result_yarn)

      Enum.empty?(project_types) ->
        %{:error => "No dependency manifest files were found"}

      true ->
        result_list = hex_report ++ json_report ++ yarn_report ++ pypi_report

        result = %{
          :state => :complete,
          :metadata => %{
            repo_count: Enum.count(result_list),
            dependency_count: deps_count
          },
          :report => %{
            :uuid => UUID.uuid1(),
            :repos => result_list
          },
          :files => files
        }

        result = AnalyzerModule.determine_risk_counts(result)

        end_time = DateTime.utc_now()

        times = %{
          start_time: DateTime.to_iso8601(start_time),
          end_time: DateTime.to_iso8601(end_time),
          duration: DateTime.diff(end_time, start_time)
        }

        metadata = Map.put_new(result[:metadata], :times, times)
        result |> Map.put(:metadata, metadata)
    end
  end
end
