# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdent do
  @spec find_files(atom | %{path: any}, atom | %{files: any, path: any}) :: [binary]
  def find_files(repo, project_type) do
    Path.wildcard(
      "#{repo.path}/#{project_type.path}/#{ProjectType.types_to_string(project_type)}"
    )
  end

  @doc """
  categorize_repo/1: takes in a Repository and will return a list
  of found project types within the repo.
  """
  def categorize_repo(repo, project_types) do
    Enum.reduce(project_types, %{}, fn project_type, acc ->
      search = find_files(repo, project_type)

      if Enum.empty?(search) do
        acc
      else
        Map.put(acc, project_type.name, search)
      end
    end)
  end
end
