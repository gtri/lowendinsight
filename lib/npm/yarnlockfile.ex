# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Npm.Yarnlockfile do
  @behaviour Parser

  @moduledoc """
    Provides yarn.lock dependency parser
  """

  @impl Parser
  def parse!(content) do
    deps =
      content
      |> YarnParser.decode()
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
