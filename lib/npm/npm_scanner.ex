defmodule Npm.Scanner do
  @moduledoc """
  Scanner scans for node dependencies to run analysis on.
  """

  @doc """
  scan: called when node? is false, returning an empty list and 0
  """
  @spec scan(boolean(), map) :: {[], 0}
  def scan(node?, _project_types) when node? == false, do: {[], 0}

  @doc """
  scan: takes in a path to node dependencies and returns the
  dependencies mapped to their analysis and the number of dependencies
  """
  @spec scan(boolean(), %{node: []}) :: {[any], non_neg_integer}
  def scan(_node?, %{node: path_to_json_list}, option \\ ".") do
    case Enum.find(path_to_json_list, &String.ends_with?(&1, "package#{option}json")) do
      nil ->
        {:error, "Must contain a package.json file"}

      path_to_package_json ->
        {direct_deps, deps_count} =
          File.read!(path_to_package_json)
          |> Npm.Packagefile.parse!()

        case Enum.find(path_to_json_list, &String.ends_with?(&1, "package-lock#{option}json")) do
          nil ->
            result_map =
              Enum.map(direct_deps, fn {lib, _version} ->
                query_npm(lib)
              end)

            {result_map, deps_count}

          path_to_package_lock_json ->
            {lib_map, _count} =
              File.read!(path_to_package_lock_json)
              |> Npm.Packagelockfile.parse!()

            result_map =
              Enum.map(lib_map, fn {lib, _version} ->
                query_npm(lib)
              end)

            {result_map, deps_count}
        end
    end
  end

  @doc """
  query_npm: function that takes in a package and returns an analysis
  on that package's repository using analyser_module.  If the package url cannot
  be reached, an error is returned.
  """
  @spec query_npm(String.t) :: {:ok, map} | String.t
  def query_npm(package) do
    encoded_id = URI.encode(package)

    HTTPoison.start()
    {:ok, response} = HTTPoison.get("https://replicate.npmjs.com/" <> encoded_id)

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