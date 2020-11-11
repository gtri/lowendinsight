# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details

defmodule Results do
  @derive [Poison.Encoder]
  defstruct [
    :commit_currency_risk,
    :commit_currency_weeks,
    :contributor_count,
    :contributor_risk,
    :functional_contributor_names,
    :functional_contributors,
    :functional_contributors_risk,
    :large_recent_commit_risk,
    :recent_commit_size_in_percent_of_codebase,
    :top10_contributors
  ]
end

defmodule Data do
  @derive [Poison.Encoder]
  defstruct [:config, :repo, :risk, :results]
end

defmodule RepoReport do
  @derive [Poison.Encoder]
  defstruct data: {}
end
