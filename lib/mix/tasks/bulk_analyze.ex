# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Mix.Tasks.Lei.BulkAnalyze do
  use Mix.Task
  @shortdoc "Run LowEndInsight and analyze a list of git repositories"
  @moduledoc ~S"""
  This is used to run a LowEndInsight scan against a repository, by cloning it locally, then looking
  into it.  Pass in the repo URL as a parameter to the task.

  #Usage
  ```
  cat url_list | mix lei.bulk_analyze | jq
  ```
  This will return a big report (prettied by jq), depending on your list quantity.
  ```
  {
  "state": "complete",
  "report": {
    "uuid": "2916881c-67d7-11ea-be2b-88e9fe666193",
    "repos": [
      {
        "header": {
          "uuid": "25b55c30-67d6-11ea-9764-88e9fe666193",
          "start_time": "2020-03-16T22:32:45.324687Z",
          "source_client": "mix task",
          "library_version": "",
          "end_time": "2020-03-16T22:33:24.152148Z",
          "duration": 39
        },
        "data": {
          "risk": "high",
          "results": {
            "top10_contributors": [
              {
  ...
  ```
  """

  def run(args) do
    file = List.first(args)

    case File.exists?(file) do
      false ->
        Mix.shell().info("\ninvalid file provided")

      true ->
        urls =
          File.read!(file)
          |> String.split("\n", trim: true)

        case Helpers.validate_urls(urls) do
          :ok ->
            {:ok, report} =
              AnalyzerModule.analyze(urls, "mix task", DateTime.utc_now(), %{types: false})

            Poison.encode!(report)
            |> Mix.shell().info()

          {:error, _} ->
            Mix.shell().info("\ninvalid file contents")
        end
    end
  end
end
