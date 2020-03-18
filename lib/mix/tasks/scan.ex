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
    path =
      cond do
        length(args) == 0 ->
          "."

        length(args) == 1 ->
          dir = List.first(args)

          case File.exists?(dir) do
            false ->
              exit({:shutdown, 15})

            true ->
              {:ok, repo} = GitModule.get_repo(dir)
              repo.path
          end
      end

    Application.load(:lowendinsight)

    ScannerModule.scan(path)
    |> Mix.shell().info()
  end
end
