# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Pypi.Requirements do
  @behaviour Parser

  @moduledoc """
    Provides a requirements.txt dependency parser		
  """

  @impl Parser
  def parse!(content) do
    deps =
      content
      |> String.split()
      |> extract_deps()
      |> Enum.to_list()

    {deps, length(deps)}
  end

  @impl Parser
  def file_names(), do: ["*requirements*.txt"]

  # needs works
  defp extract_deps(deps) do
    patterns = ["==", ">=", "<=", "<", ">", "!=", "~=", "*"]
    regex = ~r{(==)|(>=)|(<=)|[<>]|(!=)|(\~=)|(\*)}

    deps
    |> Enum.reject(&String.starts_with?(&1, "#"))
    |> Enum.map(fn dep ->
      if String.contains?(dep, patterns) do
        [dep, version] = String.split(dep, regex, parts: 2)
        {dep, version}
      else
        {dep, ""}
      end
    end)
  end
end
