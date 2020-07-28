defmodule Hex.Scanner do
  @moduledoc """
  Scanner scans for mix dependencies to run analysis on.
  """

  @doc """
  scan: called when mix? is false, returning an empty list and 0.
  """
  @spec scan(boolean(), map) :: {[], 0}
  def scan(mix?, _project_types) when mix? == false, do: {[], 0}

  @doc """
  scan: takes in a path to mix dependencies and returns the
  dependencies mapped to their analysis and the number of dependencies.
  """
  @spec scan(boolean(), %{node: []}) :: {[any], non_neg_integer}
  def scan(_mix?, %{mix: [path_to_mix_exs | path_to_mix_lock]}) do
    {_mixfile, deps_count} =
      File.read!(path_to_mix_exs)
      |> Hex.Mixfile.parse!()

    {lockfile, _count} =
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

  @spec query_hex(String.t) :: {:ok, map} | String.t
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
end
