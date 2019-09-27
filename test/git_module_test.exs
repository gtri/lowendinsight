defmodule GitModuleTest do
  use ExUnit.Case
  doctest GitModule

  setup_all do
    on_exit(
      fn ->
        File.rm_rf "xmpp4rails"
        File.rm_rf "lita-cron"  
        File.rm_rf "libconfuse"
      end
    )
    File.rm_rf "xmpp4rails"
    File.rm_rf "lita-cron"
    File.rm_rf "libconfuse"
    {:ok, repo} = GitModule.clone_repo "https://github.com/kitplummer/xmpp4rails"
    {:ok, tag_repo} = GitModule.clone_repo "https://github.com/martinh/libconfuse"
    [repo: repo, tag_repo: tag_repo]
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
    seconds = TimeHelper.get_commit_delta(date)
    weeks = TimeHelper.sec_to_weeks(seconds)
    assert 553 <= weeks
  end

  test "get commit and tag dates", context do
    {:ok, dates} = GitModule.get_tag_and_commit_dates context[:tag_repo]
    {:ok, diffs} = GitHelper.get_total_tag_commit_time_diff(dates)
    true_values = [26839644, 31666688, 68, 786301, 38662679, 12116975, 177964198, 43548340,
    71480080, 1295779, 53, 178763, 3731906, 6502379, 4714608]
    #{:ok, diff} = TimeHelper.sum_ts_diff(dates, 0)
    assert diffs == true_values
    {:ok, avg_diffs} = GitHelper.get_avg_tag_commit_time_diff(dates)

    true_avg_diffs = [1412612.8421052631, 2111112.533333333, 34.0, 43683.38888888889,
    406975.56842105265, 106289.25438596492, 2696427.242424242, 1814514.1666666667,
    1401570.1960784313, 29449.522727272728, 26.5, 25537.571428571428,
    196416.1052631579, 180621.63888888888, 392884.0]
    assert true_avg_diffs == avg_diffs
  end

  test "get code changes in last 2 commits", context do
    {:ok, commits} = GitModule.get_last_n_commits(context[:tag_repo], 2)
    {:ok, diffs} = GitModule.get_diff_2_commits(context[:tag_repo], commits)
    {:ok, files_changed, insertions, deletions} = GitHelper.parse_diff(diffs)
    assert files_changed == 1
    assert (insertions + deletions) == 23

    {:ok, total_lines, total_files_changed} = GitModule.get_total_lines(context[:repo])
    assert total_lines == 543
    assert total_files_changed == 10
  end
end
