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

    project_types_identified = ProjectIdent.get_categories(path)

    mix? = Map.has_key?(project_types_identified, :mix)
    node? = Map.has_key?(project_types_identified, :node)

    # result = Map.merge(mix_scan(mix?), npm_scan(node?))
    # result = hex_scan(mix?)

    hex_map = hex_scan(mix?)
    npm_map = npm_scan(node?)

    result = Map.merge(hex_map, npm_map, fn duplicate, v1, v2 ->
      case duplicate do
        :repos ->
          v1 ++ v2
        :metadata ->
          if Map.fetch!(hex_map["metadata"], "risk_counts") && Map.fetch!(npm_map["metadata"], "risk_counts") do
            if Map.fetch!(v1["risk_counts"], "critical") && Map.fetch!(v2["risk_counts"], "critical") do
              v1["risk_counts"]["critical"] + v2["risk_counts"]["critical"]
            end
            if Map.fetch!(v1["risk_counts"], "high") && Map.fetch!(v2["risk_counts"], "high") do
              v1["risk_counts"]["high"] + v2["risk_counts"]["high"]
            end
            if Map.fetch!(v1["risk_counts"], "medium") && Map.fetch!(v2["risk_counts"], "medium") do
              v1["risk_counts"]["medium"] + v2["risk_counts"]["medium"]
            end
            if Map.fetch!(v1["risk_counts"], "low") && Map.fetch!(v2["risk_counts"], "low") do
              v1["risk_counts"]["low"] + v2["risk_counts"]["low"]
            end
          end
        :repo_count ->
          v1 + v2
        :dependency_count ->
          v1 + v2
        _ ->
          v2
      end
    end)

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

  defp hex_scan(mix?) when mix? == true do
    {_mixfile, count} =
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

    result = %{
      :state => :complete,
      :metadata => %{repo_count: length(result_map), dependency_count: count},
      :report => %{:uuid => UUID.uuid1(), :repos => result_map}
    }

    AnalyzerModule.determine_risk_counts(result)
  end

  defp npm_scan(node?) when node? == true do
    lib_map = 
    File.read!("lib/npm/package-lock.json")
    |> Npm.Packagelockfile.parse!()

    IO.inspect "running npm scan..."

    count = length(lib_map) # package.json instead
    result_map =
      Enum.map(lib_map, fn package ->
        query_npm(package) end)

    result = %{
      :state => :complete,
      :metadata => %{repo_count: length(result_map), dependency_count: count},
      :report => %{:uuid => UUID.uuid1(), :repos => result_map}
    }

    AnalyzerModule.determine_risk_counts(result)
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
      # |> HTTPoison.Retry.autoretry(max_attempts: 5, wait: 15000, include_404s: false, retry_unknown_errors: false)

    case response.status_code do
      404 ->
        "{\"error\":\"no package found in npm\"}"
      200 -> 
        repo_info = get_repository(response.body)
        repo_url = get_url(repo_info)
        {:ok, report} = AnalyzerModule.analyze(repo_url, "npm.scan", %{types: true})
        report
      true ->
        "{\"error\":\"no source repo link available\"}"    
    end
  end

  defp get_repository(body) do
    decoded = Poison.decode!(body)
    repos =
      case Map.has_key?(decoded, "repository") do
        true -> decoded["repository"]
        false -> %{error: "no repository"}
      end
    repos
  end

  defp get_url(repo) do
    repo["url"]
    |> remove_url_prefix
  end

  defp remove_url_prefix(url) do
    String.trim_leading(url, "git+")
  end
end
