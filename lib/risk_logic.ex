# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule RiskLogic do
  @moduledoc """
  RiskLogic contains the functionality for determining risk based on
  numeric input values
  """

  @doc """
  contributor_risk/1: returns text enumeration for count
  """
  def contributor_risk(contributor_count) do
    cond do
      contributor_count < Application.fetch_env!(:lowendinsight, :critical_contributor_level) ->
        {:ok, "critical"}

      contributor_count < Application.fetch_env!(:lowendinsight, :high_contributor_level) ->
        {:ok, "high"}

      contributor_count < Application.fetch_env!(:lowendinsight, :medium_contributor_level) ->
        {:ok, "medium"}

      contributor_count >= Application.fetch_env!(:lowendinsight, :medium_contributor_level) ->
        {:ok, "low"}
    end
  end

  @doc """
  commit_currency_risk/1: returns text enumeration for commit currency risk
  """
  def commit_currency_risk(delta_in_weeks) do
    cond do
      delta_in_weeks < Application.fetch_env!(:lowendinsight, :medium_currency_level) ->
        {:ok, "low"}

      delta_in_weeks < Application.fetch_env!(:lowendinsight, :high_currency_level) ->
        {:ok, "medium"}

      delta_in_weeks < Application.fetch_env!(:lowendinsight, :critical_currency_level) ->
        {:ok, "high"}

      delta_in_weeks >= Application.fetch_env!(:lowendinsight, :critical_currency_level) ->
        {:ok, "critical"}
    end
  end

  @doc """
  last_commit_size_risk/1: returns a text enumeration for the risk based on the size of the last commit
  """
  def commit_change_size_risk(change_percent) do
    cond do
      change_percent < Application.fetch_env!(:lowendinsight, :medium_large_commit_level) ->
        {:ok, "low"}

      change_percent < Application.fetch_env!(:lowendinsight, :high_large_commit_level) ->
        {:ok, "medium"}

      change_percent < Application.fetch_env!(:lowendinsight, :critical_large_commit_level) ->
        {:ok, "high"}

      change_percent >= Application.fetch_env!(:lowendinsight, :critical_large_commit_level) ->
        {:ok, "critical"}
    end
  end

  @doc """
  functional_contributors_risk/1: returns the enumerated risk based on input contributors list
  """
  def functional_contributors_risk(contributors) do
    cond do
      contributors >=
          Application.fetch_env!(:lowendinsight, :medium_functional_contributors_level) ->
        {:ok, "low"}

      contributors >= Application.fetch_env!(:lowendinsight, :high_functional_contributors_level) ->
        {:ok, "medium"}

      contributors >=
          Application.fetch_env!(:lowendinsight, :critical_functional_contributors_level) ->
        {:ok, "high"}

      contributors <
          Application.fetch_env!(:lowendinsight, :critical_functional_contributors_level) ->
        {:ok, "critical"}
    end
  end
end
