# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Mix.Tasks.Analyze do
  use Mix.Task
  @shortdoc "Run LowEndInsight and analyze a git repository"
  @moduledoc ~S"""
  This is used to run a LowEndInsight scan against a repository, by cloning it locally, then looking
  into it.  Pass in the repo URL as a parameter to the task.

  #Usage
  ```
  mix analyze "https://github.com/kitplummer/xmpp4rails"
  ```
  This will return a basic report as an Elixir Map.
  ```
  {:ok,
   %{
     data: %{
       commit_currency_risk: "critical",
       commit_currency_weeks: 563,
       contributor_count: 1,
       contributor_risk: "critical",
       functional_contributor_names: ["Kit Plummer"],
       functional_contributors: 1,
       functional_contributors_risk: "critical",
       large_recent_commit_risk: "low",
       recent_commit_size_in_percent_of_codebase: 0.003683241252302026,
       repo: "https://github.com/kitplummer/xmpp4rails",
       risk: "critical"
     },
     header: %{
       duration: 0,
       end_time: "2019-10-24 14:11:56.605288Z",
       source_client: "iex",
       start_time: "2019-10-24 14:11:56.035968Z",
       uuid: "3ca83ec4-f668-11e9-90a1-88e9fe666193"
     }
   }}
  ```
  """
  def run(url) do
    report = AnalyzerModule.analyze(url, "mix task")
    IO.puts(report)
  end
end
