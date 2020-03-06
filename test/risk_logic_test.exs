# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule RiskLogicTest do
  use ExUnit.Case, async: true
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
    assert RiskLogic.commit_change_size_risk(0.20) == {:ok, "medium"}
  end

  test "confirm large commit high" do
    assert RiskLogic.commit_change_size_risk(0.16) == {:ok, "low"}
  end

  test "confirm large commit critical" do
    assert RiskLogic.commit_change_size_risk(0.45) == {:ok, "critical"}
  end

  test "confirm functional commiters low" do
    assert RiskLogic.functional_contributors_risk(6) == {:ok, "low"}
    assert RiskLogic.functional_contributors_risk(5) == {:ok, "low"}
  end

  test "confirm functional commiters medium" do
    assert RiskLogic.functional_contributors_risk(4) == {:ok, "medium"}
    assert RiskLogic.functional_contributors_risk(3) == {:ok, "medium"}
  end

  test "confirm functional commiters high" do
    assert RiskLogic.functional_contributors_risk(2) == {:ok, "high"}
  end

  test "confirm functional commiters critical" do
    assert RiskLogic.functional_contributors_risk(1) == {:ok, "critical"}
  end
end
