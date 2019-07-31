defmodule TimeHelperTest do
  use ExUnit.Case

  test "get weeks from seconds" do
    assert TimeHelper.sec_to_weeks(333282014) == {:ok, 551}
  end
end
