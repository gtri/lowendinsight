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

    {hex_reports_list, hex_deps_count} = hex_scan(mix?)
    {npm_reports_list, npm_deps_count} = npm_scan(node?)

    result_list = hex_reports_list ++ npm_reports_list

    result = %{
      :state => :complete,
      :metadata => %{repo_count: Enum.count(result_list), dependency_count: hex_deps_count + npm_deps_count},
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
  end

  defp hex_scan(mix?) when mix? == false, do: {%{}, 0}

  defp hex_scan(_mix?) do
    {_mixfile, deps_count} =
      File.read!("./mix.exs")
      |> Hex.Mixfile.parse!()

    {lockfile, _count} =
    File.read!("./mix.lock")
    |> Hex.Lockfile.parse!()

    # lib_map = Hex.Encoder.mixfile_map(mixfile)
    lib_map = Hex.Encoder.lockfile_map(lockfile)

    result_map =
      Enum.map(lib_map, fn {key, _value} ->
        query_hex(key)
      end)
    
    {Enum.to_list(result_map), deps_count}
  end

  defp npm_scan(node?) when node? == false, do: {[], 0}

  defp npm_scan(_node?) do
    {_direct_deps, deps_count} =
      File.read!("./package.json") # not necessarily at root...
      |> Npm.Packagefile.parse!()

    # to be implemented => if package-lock.json doesn't exist, do a scan of 1st-degree dependencies (package.json)
    {lib_map, _count} = 
      File.read!("./package-lock.json") # not necessarily at root...
      |> Npm.Packagelockfile.parse!()

    result_map =
      Enum.map(lib_map, fn {lib, _version} ->
        query_npm(lib) 
      end)
 
    {result_map, deps_count}
  end

  defp query_hex(package) do
    HTTPoison.start()
    response = HTTPoison.get!("https://hex.pm/api/packages/#{package}")

    case response.status_code do
      404 ->
        "{\"error\":\"no package found in hex\"}"

      200 ->
        hex_package_links = Poison.decode!(response.body)["meta"]["links"]
        # Hex.pm API doesn't handle case stuff for us.
        hex_package_links =
          for {k, v} <- hex_package_links, into: %{}, do: {String.downcase(k), v}

        cond do
          Map.has_key?(hex_package_links, "github") ->
            {:ok, report} =
              AnalyzerModule.analyze(hex_package_links["github"], "mix.scan", %{types: true})
            report

          Map.has_key?(hex_package_links, "bitbucket") ->
            {:ok, report} =
              AnalyzerModule.analyze(hex_package_links["bitbucket"], "mix.scan", %{types: true})
            report

          Map.has_key?(hex_package_links, "gitlab") ->
            {:ok, report} =
              AnalyzerModule.analyze(hex_package_links["gitlab"], "mix.scan", %{types: true})
            report

          true ->
            "{\"error\":\"no source repo link available\"}"
        end
    end
  end

  def query_npm(package) do
    encoded_id = URI.encode package

    HTTPoison.start
    {:ok, response} =
      HTTPoison.get "https://replicate.npmjs.com/" <> encoded_id

    case response.status_code do
      404 ->
        "{\"error\":\"no package found in npm\"}"
      200 -> 
        repo_info = get_npm_repository(response.body)
        repo_url = Helpers.remove_git_prefix(repo_info["url"])
        {:ok, report} = AnalyzerModule.analyze(repo_url, "mix.scan", %{types: true})
        report
      true ->
        "{\"error\":\"no source repo link available\"}"    
    end
  end

  defp get_npm_repository(body) do
    decoded = Poison.decode!(body)
    repos =
      case Map.has_key?(decoded, "repository") do
        true -> decoded["repository"]
        false -> %{error: "no repository"}
      end
    repos
  end
end
