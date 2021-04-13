# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Mix.Tasks.Lei.Scan do
  use Mix.Task
  @shortdoc "Run LowEndInsight scan against a local project"
  @moduledoc ~S"""
  This is used to run a LowEndInsight scanner against a project.

  #Usage
  ```
  mix lei.scan
  ```
  This will return a basic list of reports in JSON format. LowEndInsight
  will scan the `mix.exs` file for the list of dependencies, enumerating
  through them and fetching the source repo URL from the Hex.pm API.  Then
  the scanner passes that URL to LowEndInsight which does a temporary clone
  to perform its analysis of each dependency.
  """
  def run(args) do
    Mix.Task.run("app.start")

    cond do
      length(args) == 0 ->
        ScannerModule.scan(".")
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
            |> ScannerModule.scan()
            |> Mix.shell().info()
        end
    end
  end
end
