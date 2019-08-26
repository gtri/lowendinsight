defmodule GitModuleTest do
  use ExUnit.Case
  doctest GitModule

  setup do
    on_exit(
      fn ->
        File.rm_rf "xmpp4rails"
        File.rm_rf "lita-cron"
      end
    )
  end

  test "get contributor list 1" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/xmpp4rails"
    assert {:ok, 1} == count
  end

  test "get contributor list 3" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/lita-cron"
    assert {:ok, 3} == count
  end

  test "get contributor list bad repo" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/blah"
    assert {:error, "Repository not found"} == count
  end

  test "get last commit date" do
    date = GitModule.get_last_commit_date "https://github.com/kitplummer/xmpp4rails"
    assert {:ok, "2009-01-06T20:23:20-07:00"} == date
  end

  test "convert to delta" do
    {:ok, date} = GitModule.get_last_commit_date "https://github.com/kitplummer/xmpp4rails"
    {:ok, seconds} = TimeHelper.get_commit_delta(date)
    {:ok, weeks} = TimeHelper.sec_to_weeks(seconds)
    assert 553 <= weeks

  end

end
