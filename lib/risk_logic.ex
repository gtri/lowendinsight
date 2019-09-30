defmodule RiskLogic do
  @moduledoc """
  RiskLogic contains the functionality for determining risk based on
  numeric input values
  """

  @doc """
  contributor_risk: returns text enumeration for count
  """
  def contributor_risk(contributor_count) do
    cond do
      contributor_count < Application.fetch_env!(:lowendinsight, :critical_contributor_par_level) -> {:ok, "critical"}
      contributor_count < Application.fetch_env!(:lowendinsight, :high_contributor_par_level) -> {:ok, "high"}
      contributor_count < Application.fetch_env!(:lowendinsight, :medium_contributor_par_level) -> {:ok, "medium"}
      contributor_count >= Application.fetch_env!(:lowendinsight, :medium_contributor_par_level) -> {:ok, "low"}
    end
  end

  @doc """
  commit_currency_risk: returns text enumeration for commit currency risk
  """
  def commit_currency_risk(delta_in_weeks) do
    cond do
      delta_in_weeks < Application.fetch_env!(:lowendinsight, :medium_currency_par_level) -> {:ok, "low"}
      delta_in_weeks < Application.fetch_env!(:lowendinsight, :high_currency_par_level) -> {:ok, "medium"}
      delta_in_weeks < Application.fetch_env!(:lowendinsight, :critical_currency_par_level) -> {:ok, "high"}
      delta_in_weeks >= Application.fetch_env!(:lowendinsight, :critical_currency_par_level) -> {:ok, "critical"}
    end
  end

  @doc """
  last_commit_size_risk: returns a text enumeration for the risk based on the size of the last commit
  """
  def commit_change_size_risk(change_percent) do
    cond do
      change_percent < Application.fetch_env!(:lowendinsight, :low_large_commit_risk) -> {:ok, "low"}
      change_percent < Application.fetch_env!(:lowendinsight, :medium_large_commit_risk) -> {:ok, "medium"}
      change_percent < Application.fetch_env!(:lowendinsight, :high_large_commit_risk) -> {:ok, "high"}
      change_percent >= Application.fetch_env!(:lowendinsight, :high_large_commit_risk) -> {:ok, "critical"}
    end
  end


  def functional_contributors_risk(contributors) do
    cond do
      contributors >= Application.fetch_env!(:lowendinsight, :low_functional_contributors_risk) -> {:ok, "low"}
      contributors >= Application.fetch_env!(:lowendinsight, :medium_functional_contributors_risk) -> {:ok, "medium"}
      contributors >= Application.fetch_env!(:lowendinsight, :high_functional_contributors_risk) -> {:ok, "high"}
      contributors < Application.fetch_env!(:lowendinsight, :high_functional_contributors_risk) -> {:ok, "critical"}
    end
  end
end
