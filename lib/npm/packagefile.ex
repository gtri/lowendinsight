# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Npm.Packagefile do
  @behaviour Parser

  @moduledoc """
    Provides package.json and package-lock.json dependency parser		
  """

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

  defp extract_deps({:ok, %{"dependencies" => deps, "devDependencies" => devDeps}}),
    do: Map.merge(deps, devDeps)

  defp extract_deps({:ok, %{"dependencies" => deps}}), do: deps

  defp extract_deps({:ok, %{"devDependencies" => devDeps}}), do: devDeps
end
