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
end
