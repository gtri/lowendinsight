# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule TimeHelperTest do
  use ExUnit.Case, async: true
  doctest TimeHelper

  test "convert seconds to string" do
    string = TimeHelper.sec_to_str(11_223_344)
    assert "18 wk, 3 d, 21 hr, 35 min, 44 sec" == string
  end

  test "get weeks from seconds" do
    assert TimeHelper.sec_to_weeks(333_282_014) == 551
  end

  test "compute delta" do
    seconds = TimeHelper.get_commit_delta("2009-01-07T03:23:20Z")
    weeks = TimeHelper.sec_to_weeks(seconds)
    assert weeks > 550

    seconds = TimeHelper.get_commit_delta("2019-01-07T03:23:20Z")
    weeks = TimeHelper.sec_to_weeks(seconds)
    assert weeks >= 30
  end
end
