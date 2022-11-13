# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Hex.Scanner do
  require HTTPoison.Retry

  @moduledoc """
  Scanner scans for mix dependencies to run analysis on.
  """

  def scan(mix?, _project_types) when mix? == false, do: {[], 0}

  @doc """
  scan: takes in a path to mix dependencies and returns the
  dependencies mapped to their analysis and the number of dependencies.
  """
  @spec scan(boolean(), %{node: []}) :: {[any], non_neg_integer}
  def scan(_mix?, %{mix: [path_to_mix_exs | path_to_mix_lock]}) do
    {:ok, {_mixfile, deps_count}} =
      File.read!(path_to_mix_exs)
      |> Hex.Mixfile.parse!()

    {:ok, {lockfile, _count}} =
      File.read!(path_to_mix_lock)
      |> Hex.Lockfile.parse!()

    # lib_map = Hex.Encoder.mixfile_map(mixfile)
    lib_map = Hex.Encoder.lockfile_map(lockfile)

    result_map =
      Enum.map(lib_map, fn {key, _value} ->
        query_hex(key)
      end)

    {result_map, deps_count}
  end

  defp query_hex(package) do
    HTTPoison.start()

    response =
      HTTPoison.get!("https://hex.pm/api/packages/#{package}")
      |> HTTPoison.Retry.autoretry(
        max_attempts: 5,
        wait: 15000,
        include_404s: false,
        retry_unknown_errors: false
      )

    case response.status_code do
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
            {:ok, report} = AnalyzerModule.analyze(package, "mix.scan", %{types: true})

            report
        end

      _ ->
        {:ok, report} = AnalyzerModule.analyze(package, "mix.scan", %{types: true})

        report
    end
  end
end
