defmodule RiskLogicTest do
  use ExUnit.Case
  doctest RiskLogic

  test "confirm contributor critical" do
    assert RiskLogic.contributor_risk(1) == {:ok, "critical"}
  end

  test "confirm contributor high" do
    assert RiskLogic.contributor_risk(2) == {:ok, "high"}
  end

  test "confirm contributor medium" do
    assert RiskLogic.contributor_risk(4) == {:ok, "medium"}
  end

  test "confirm contributor low" do
    assert RiskLogic.contributor_risk(5) == {:ok, "low"}
  end

  test "confirm currency critical" do
    assert RiskLogic.commit_currency_risk(104) == {:ok, "critical"}
  end

  test "confirm currency more than critical" do
    assert RiskLogic.commit_currency_risk(105) == {:ok, "critical"}
  end

  test "confirm currency high" do
    assert RiskLogic.commit_currency_risk(52) == {:ok, "high"}
  end

  test "confirm currency more than high" do
    assert RiskLogic.commit_currency_risk(53) == {:ok, "high"}
  end

  test "confirm currency medium" do
    assert RiskLogic.commit_currency_risk(26) == {:ok, "medium"}
  end

  test "confirm currency more than medium" do
    assert RiskLogic.commit_currency_risk(27) == {:ok, "medium"}
  end

  test "confirm currency low" do
    assert RiskLogic.commit_currency_risk(25) == {:ok, "low"}
  end

  test "confirm large commit low" do
    assert RiskLogic.commit_change_size_risk(0.04) == {:ok, "low"}
  end
  test "confirm large commit medium" do
    assert RiskLogic.commit_change_size_risk(0.10) == {:ok, "medium"}
  end
  test "confirm large commit high" do
    assert RiskLogic.commit_change_size_risk(0.16) == {:ok, "high"}
  end
  test "confirm large commit critical" do
    assert RiskLogic.commit_change_size_risk(0.35) == {:ok, "critical"}
  end

end
