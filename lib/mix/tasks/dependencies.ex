# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Mix.Tasks.Lei.Dependencies do
  use Mix.Task
  @shortdoc "Run LowEndInsight and generate a flat transitive-dependency list"
  @moduledoc ~S"""
  This is used to run LowEndInsight to generate a transitive-dependency
  list, as JSON, for a given repository.

  #Usage
  ```
  mix lei.dependencies
  ```
  This will return a JSON arrary of all dependencies for a given repository.
  The list is generated from the project's mix.lock file.
  """
  def run(args) do
    Application.load(:lowendinsight)

    cond do
      length(args) == 0 ->
        ScannerModule.dependencies(".")
        |> Mix.shell().info()

      length(args) == 1 ->
        dir = List.first(args)

        case File.exists?(dir) do
          false ->
            "Invalid path"
            |> Mix.shell().info()

          true ->
            {:ok, repo} = GitModule.get_repo(dir)

            repo.path
            |> ScannerModule.dependencies()
            |> Mix.shell().info()
        end
    end
  end
end
