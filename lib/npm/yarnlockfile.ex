defmodule Npm.Yarnlockfile do
  @behaviour Parser

  @moduledoc """
    Provides yarn.lock dependency parser
  """
  @doc """
  parse!: parses yarn.lock dependencies, returning a map of those
  dependencies along with the count of total dependencies.
  """
  @impl Parser
  def parse!(content) do
    deps =
      content
      |> YarnParser.parse()
      |> extract_deps()
      |> remove_version_labels()
      |> Enum.to_list()

    {deps, length(deps)}
  end

  @impl Parser
  def file_names(), do: ["yarn.lock"]

  defp extract_deps({:ok, %{"comments" => _} = map}), do: Map.delete(map, "comments")

  defp remove_version_labels(deps) do
    Enum.reduce(deps, %{}, fn {dep_key, %{"version" => version}}, acc ->
        dep_name = List.first(String.split(dep_key, ~r{@.+}, parts: 2))
        case Map.fetch(acc, dep_name) do
          :error ->
            Map.put(acc, dep_name, version)
          {:ok, dup_version} ->
          if Float.parse(dup_version) < Float.parse(version), 
            do: Map.put(acc, dep_name, version),
            else: acc
        end
    end)
  end
end