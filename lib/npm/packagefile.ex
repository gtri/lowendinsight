defmodule Npm.Packagefile do
  @behaviour Parser

  @impl Parser
  def parse!(content) do
    deps =
      content
      |> Jason.decode()
      |> extract_deps()
      |> Enum.to_list()
      |> Enum.map(fn {dependency, info} ->
          if is_map(info) && Map.fetch!(info, "version"),
            do: {dependency, info["version"]},
            else: {dependency, List.last(String.split(info, ~r{[\^|~]}, parts: 2))}
        end)

    {deps, length(deps)}
  end

  @impl Parser
  def file_names(), do: ["package.json", "package-lock.json"]

  defp extract_deps({:ok, %{"dependencies" => deps, "devDependencies" => devDeps}}), do: Map.merge(deps, devDeps)

  defp extract_deps({:ok, %{"dependencies" => deps}}), do: deps

  defp extract_deps({:ok, %{"devDependencies" => devDeps}}), do: devDeps
end