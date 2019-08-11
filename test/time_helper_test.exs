defmodule TimeHelperTest do
  use ExUnit.Case

  test "get weeks from seconds" do
    assert TimeHelper.sec_to_weeks(333282014) == {:ok, 551}
  end

  test "test delta" do
    {:ok, seconds} = TimeHelper.get_commit_delta("2009-01-07T03:23:20Z")
    {:ok, weeks} = TimeHelper.sec_to_weeks(seconds)
    assert weeks > 550

    {:ok, seconds} = TimeHelper.get_commit_delta("2019-01-07T03:23:20Z")
    {:ok, weeks} = TimeHelper.sec_to_weeks(seconds)
    assert weeks >= 30

  end
end
