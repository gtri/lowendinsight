# defmodule Config do
#   @derive [Poison.Encoder]
#   defstruct config: {}
# end

# defmodule Repo do
#   @derive [Poison.Encoder]
#   defstruct repo: ""
# end

# defmodule Risk do
#   @derive [Poison.Encoder]

#   defstruct risk: ""
# end

defmodule Results do
  @derive [Poison.Encoder]
  defstruct [:commit_currency_risk,
             :commit_currency_weeks,
             :contributor_count,
             :contributor_risk,
             :functional_contributor_names,
             :functional_contributors,
             :functional_contributors_risk,
             :large_recent_commit_risk,
             :recent_commit_size_in_percent_of_codebase,
             :top10_contributors]
end

defmodule Data do
  @derive [Poison.Encoder]
  defstruct [:config, :repo, :risk, :results]
end

defmodule RepoReport do
  @derive [Poison.Encoder]
  defstruct data: {}
end

