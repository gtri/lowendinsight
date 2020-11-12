# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Mix.Tasks.Lei.Analyze do
  use Mix.Task
  @shortdoc "Run LowEndInsight and analyze a git repository"
  @moduledoc ~S"""
  This is used to run a LowEndInsight scan against a repository, by cloning it locally, then looking
  into it.  Pass in the repo URL as a parameter to the task.

  #Usage
  ```
  mix lei.analyze "https://github.com/kitplummer/xmpp4rails" | jq
  ```
  This will return a basic report (prettied by jq) as an Elixir Map.
  ```
  {
    "data": {
      "commit_currency_risk": "critical",
      "commit_currency_weeks": 563,
      "contributor_count": 1,
      "contributor_risk": "critical",
      "functional_contributor_names": [
        "Kit Plummer"
      ],
      "functional_contributors": 1,
      "functional_contributors_risk": "critical",
      "large_recent_commit_risk": "low",
      "recent_commit_size_in_percent_of_codebase": 0.003683241252302026,
      "repo": [
        "https://github.com/kitplummer/xmpp4rails"
      ],
      "risk": "critical"
    },
    "header": {
      "duration": 1,
      "end_time": "2019-10-24 16:21:56.252768Z",
      "source_client": "mix task",
      "start_time": "2019-10-24 16:21:55.692010Z",
      "uuid": "659b37a2-f67a-11e9-ab5d-88e9fe666193"
    }
  }
  ```
  """
  def run(url) do
    Mix.Task.run("app.start")

    {:ok, report} = AnalyzerModule.analyze(url, "mix task", DateTime.utc_now(), %{types: true})

    Poison.encode!(report)
    |> Mix.shell().info()
  end
end
