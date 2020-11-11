defmodule Pypi.Scanner do
  require HTTPoison.Retry

  @moduledoc """
  Scanner scans for python dependencies to run analysis on.
  """

  @doc """
  scan: called when pi? is false, returning an empty list and 0
  """
  @spec scan(boolean(), map) :: {[], 0}
  def scan(pypi?, _project_types) when pypi? == false, do: {[], 0}

  @doc """
  scan: takes in a path to node dependencies and returns the
  dependencies mapped to their analysis and the number of dependencies
  """
  @spec scan(boolean(), %{python: []}) :: {[any], non_neg_integer}
  def scan(_pypi?, %{python: paths_to_python_files}, option \\ ".") do
    path_to_requirements =
      Enum.find(paths_to_python_files, &String.ends_with?(&1, "requirements#{option}txt"))

    if path_to_requirements do
      {direct_deps, deps_count} =
        File.read!(path_to_requirements)
        |> Pypi.Requirements.parse!()

      result_map =
        Enum.map(direct_deps, fn {lib, _version} ->
          query_pypi(lib)
        end)

      {result_map, deps_count}
    else
      {:error, "Must contain a requirements.txt file"}
    end
  end

  @doc """
  query_npm: function that takes in a package and returns an analysis
  on that package's repository using analyser_module.  If the package url cannot
  be reached, an error is returned.
  """
  @spec query_pypi(String.t()) :: {:ok, map} | String.t()
  def query_pypi(package) do
    encoded_id = URI.encode(package)

    HTTPoison.start()

    {:ok, response} =
      HTTPoison.get("https://pypi.org/pypi/" <> encoded_id <> "/json")
      |> HTTPoison.Retry.autoretry(
        max_attempts: 5,
        wait: 15000,
        include_404s: false,
        retry_unknown_errors: false
      )

    case response.status_code do
      200 ->
        {:ok, response} = Jason.decode(response.body)
        info = response["info"]

        cond do
          is_map(info["project_urls"]) && Map.has_key?(info["project_urls"], "Code") ->
            url = info["project_urls"]["Code"]
            {:ok, report} = AnalyzerModule.analyze(url, "mix.scan", %{types: true})
            report

          is_map(info["project_urls"]) && Map.has_key?(info["project_urls"], "Source Code") ->
            url = info["project_urls"]["Source Code"]
            {:ok, report} = AnalyzerModule.analyze(url, "mix.scan", %{types: true})
            report

          is_map(info["project_urls"]) && Map.has_key?(info["project_urls"], "Source") ->
            url = info["project_urls"]["Source"]
            {:ok, report} = AnalyzerModule.analyze(url, "mix.scan", %{types: true})
            report

          is_map(info["project_urls"]) && Map.has_key?(info["project_urls"], "Homepage") ->
            url = info["project_urls"]["Homepage"]
            {:ok, report} = AnalyzerModule.analyze(url, "mix.scan", %{types: true})
            report

          is_map(info) && Map.has_key?(info, "download_url") ->
            url = String.trim_trailing(response["info"]["download_url"], "/tags")
            # if String.contains?(url, ["github", "bitbucket"]) do
            {:ok, report} = AnalyzerModule.analyze(url, "mix.scan", %{types: true})
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
