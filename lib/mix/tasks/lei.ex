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
  This will return a basic report in JSON format:
  ```
  {\"repo\":[\"https://github.com/kitplummer/xmpp4rails\"],\"contributor_count\":1,\"contributor_risk\":\"critical\",\"commit_currency_weeks\":559,\"commit_currency_risk\":\"critical\"}
  ```
  """
  def run(url) do
    report = AnalyzerModule.analyze(url, "mix task")
    IO.puts report
  end
end
