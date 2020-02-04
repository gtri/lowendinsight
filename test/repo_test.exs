defmodule RepoTest do
  use ExUnit.Case

  test "repo struct encodes and decodes correctly" do
    e_repo = %{
      :repo => "https://github.com/kitplummer/xmpp4rails",
      :results => %{
        :commit_currency_risk => "critical",
        :commit_currency_weeks => 52,
        :contributor_count => 1,
        :contributor_risk => "critical",
        :functional_contributor_names => ["Kit Plummer"],
        :functional_contributors => 1,
        :functional_contributors_risk => "critical",
        :large_recent_commit_risk => "low",
        :recent_commit_size_in_percent_of_codebase => 0.003683241252302026,
        :top10_contributors => [%{"Kit Plummer" => 7}]
      },
      :risk => "critical",
      :config => Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight))
    }
    
    s_repo = %RepoReport{data: e_repo}
    j_repo = Poison.encode!(s_repo)
    d_repo = Poison.decode!(j_repo, as: %RepoReport{data: %Data{results: %Results{}}})
    IO.inspect d_repo[%Data{}]

    assert d_repo[:data][:risk] == "critical"
  end
end