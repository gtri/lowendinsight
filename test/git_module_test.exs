defmodule GitModuleTest do
  use ExUnit.Case
  doctest GitModule

  setup_all do
    on_exit(
      fn ->
        File.rm_rf "xmpp4rails"
        File.rm_rf "lita-cron"
      end
    )
    {:ok, repo} = GitModule.clone_repo "https://github.com/kitplummer/xmpp4rails"
    [repo: repo]
  end

  setup do
    # yeah, this is empty, just here for posterity.  this would run before each
    :ok
  end

  test "get contributor list 1", %{repo: repo} do
    count = GitModule.get_contributor_count repo
    assert {:ok, 1} == count
  end

  test "get contributor list 3" do
    {:ok, lc_repo} = GitModule.clone_repo "https://github.com/kitplummer/lita-cron"
    count = GitModule.get_contributor_count lc_repo
    assert {:ok, 3} == count
  end

  test "get last commit date", context do
    date = GitModule.get_last_commit_date context[:repo]
    assert {:ok, "2009-01-06T20:23:20-07:00"} == date
  end

  test "convert to delta", context do
    {:ok, date} = GitModule.get_last_commit_date context[:repo]
    {:ok, seconds} = TimeHelper.get_commit_delta(date)
    {:ok, weeks} = TimeHelper.sec_to_weeks(seconds)
    assert 553 <= weeks

  end

end
