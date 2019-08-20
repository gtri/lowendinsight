defmodule Analyzer do
  @moduledoc """
  Analyzer takes in a repo url and coordinates the analysis,
  returning a simple JSON report.
  """

  def analyse(url) do
    {:ok, slug} = Helpers.get_slug(url)

    {:ok, contributor_count} = GithubModule.get_contributors_count(slug)
    {:ok, last_commit_date} = GithubModule.get_last_commit_date(slug)
    {:ok, delta_in_weeks} = TimeHelper.get_commit_delta(last_commit_date)

    {:ok, contributor_risk} = RiskLogic.contributor_risk(contributor_count)
    {:ok, currency_risk} = RiskLogic.commit_currency_risk(delta_in_weeks)

    %{"contributor_count" => contributor_count,
      "delta_in_weeks" => delta_in_weeks,
      "contributor_risk" => contributor_risk,
      "currency_risk" => currency_risk}
  end
end
