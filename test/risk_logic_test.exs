defmodule RiskLogicTest do
  use ExUnit.Case
  doctest RiskLogic

  test "confirm critical" do
    assert RiskLogic.contributor_risk(1) == {:ok, "critical"}
  end

  test "confirm high" do
    assert RiskLogic.contributor_risk(2) == {:ok, "high"}
  end

  test "confirm medium" do
    assert RiskLogic.contributor_risk(4) == {:ok, "medium"}
  end

  test "confirm low" do
    assert RiskLogic.contributor_risk(5) == {:ok, "low"}
  end

end
