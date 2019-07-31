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
      contributor_count < Application.fetch_env!(:lowendinsight, :critcial_contributor_par_level) -> {:ok, "critical"}
      contributor_count < Application.fetch_env!(:lowendinsight, :high_contributor_par_level) -> {:ok, "high"}
      contributor_count < Application.fetch_env!(:lowendinsight, :medium_contributor_par_level) -> {:ok, "medium"}
      contributor_count >= Application.fetch_env!(:lowendinsight, :medium_contributor_par_level) -> {:ok, "low"}
    end
  end
end
