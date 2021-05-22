# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GitModuleTest do
  use ExUnit.Case
  doctest GitModule

  setup_all do
    # on_exit(fn ->
    # end)

    {:ok, tmp_path} = Temp.path("lei")

    {:ok, repo} = GitModule.clone_repo("https://github.com/kitplummer/xmpp4rails", tmp_path)
    {:ok, tag_repo} = GitModule.clone_repo("https://github.com/kitplummer/libconfuse", tmp_path)

    {:ok, bitbucket_repo} =
      GitModule.clone_repo("https://bitbucket.org/kitplummer/clikan", tmp_path)

    {:ok, gitlab_repo} =
      GitModule.clone_repo("https://gitlab.com/kitplummer/infrastructure", tmp_path)

    {:ok, gitlab_subgroup_repo} =
      GitModule.clone_repo("https://gitlab.com/lowendinsight/test/pymodule", tmp_path)

    {:ok, kitrepo} = GitModule.clone_repo("https://github.com/kitplummer/kit", tmp_path)

    {:ok, this_repo} = GitModule.get_repo(".")

    [
      tmp_path: tmp_path,
      repo: repo,
      tag_repo: tag_repo,
      bitbucket_repo: bitbucket_repo,
      gitlab_repo: gitlab_repo,
      gitlab_subgroup_repo: gitlab_subgroup_repo,
      kitrepo: kitrepo,
      this_repo: this_repo
    ]
  end

  setup do
    # yeah, this is empty, just here for posterity.  this would run before each
    :ok
  end

  test "get current hash", %{repo: repo} do
    assert {:ok, "f47ee5f5ef7fb4dbe3d5d5f54e278ea941cb0332"} == GitModule.get_hash(repo)
  end

  test "get default branch", %{repo: repo} do
    assert {:ok, "refs/remotes/origin/master"} = GitModule.get_default_branch(repo)
  end

  test "get contributor list 1", %{repo: repo} do
    count = GitModule.get_contributor_count(repo)
    assert {:ok, 1} == count
  end

  test "get contributor list 3", %{tmp_path: tmp_path} do
    {:ok, lc_repo} = GitModule.clone_repo("https://github.com/kitplummer/lita-cron", tmp_path)
    count = GitModule.get_contributor_count(lc_repo)
    assert {:ok, 4} == count
  end

  test "get contribution maps", %{kitrepo: kitrepo} do
    {:ok, maps} = GitModule.get_contributions_map(kitrepo)

    expected_array = [
      %{contributions: 358, name: "Ben Morris"},
      %{contributions: 64, name: "Kit Plummer"},
      %{contributions: 6, name: "Tyler Bezera"},
      %{contributions: 4, name: "Jakub Stasiak"},
      %{contributions: 2, name: "pixeljoelson"},
      %{contributions: 1, name: "MIURA Masahiro"},
      %{contributions: 1, name: "0verse"},
      %{contributions: 1, name: "degussa"},
      %{contributions: 1, name: "0verse"}
    ]

    assert Enum.at(expected_array, 0) == Enum.at(maps, 0)
  end

  test "get cleaned contribution map", %{kitrepo: kitrepo} do
    expected = [
      %{contributions: 358, name: "Ben Morris", email: "ben@bendmorris.com", merges: 2},
      %{contributions: 64, name: "Kit Plummer", email: "kitplummer@gmail.com", merges: 4},
      %{contributions: 6, name: "Tyler Bezera", email: "TylerJessilynn@gmail.com", merges: 0},
      %{contributions: 4, name: "Jakub Stasiak", email: "jakub@stasiak.at", merges: 0},
      %{contributions: 2, name: "pixeljoelson", email: "pixeljoelson@gmail.com", merges: 0},
      %{contributions: 1, name: "MIURA Masahiro", email: "echochamber@gmail.com", merges: 0},
      %{contributions: 1, name: "0verse", email: "ali.h.caliskan@protonmail.com", merges: 0},
      %{contributions: 1, name: "degussa", email: "aron@mojang.com", merges: 0},
      %{
        contributions: 1,
        email: "44509301+0verse@users.noreply.github.com",
        merges: 0,
        name: "0verse"
      }
    ]

    {:ok, result} = GitModule.get_clean_contributions_map(kitrepo)
    assert Enum.at(expected, 1) == Enum.at(result, 1)
  end

  test "get commit dates", context do
    dates = GitModule.get_commit_dates(context[:repo])

    assert {:ok,
            [
              1_231_298_600,
              1_208_905_906,
              1_208_905_647,
              1_208_902_657,
              1_208_902_186,
              1_208_898_811,
              1_208_896_913
            ]} == dates
  end

  test "get last commit date", context do
    date = GitModule.get_last_commit_date(context[:repo])
    assert {:ok, "2009-01-06T20:23:20-07:00"} == date
  end

  test "convert to delta", context do
    {:ok, date} = GitModule.get_last_commit_date(context[:repo])
    seconds = TimeHelper.get_commit_delta(date)
    weeks = TimeHelper.sec_to_weeks(seconds)
    assert 553 <= weeks
  end

  test "get commit and tag dates", context do
    {:ok, dates} = GitModule.get_tag_and_commit_dates(context[:tag_repo])
    {:ok, diffs} = GitHelper.get_total_tag_commit_time_diff(dates)

    true_values = [
      26_839_644,
      31_666_688,
      68,
      786_301,
      38_662_679,
      12_116_975,
      177_964_198,
      43_548_340,
      71_480_080,
      1_295_779,
      53,
      178_763,
      3_731_906,
      6_502_379,
      4_714_608
    ]

    # {:ok, diff} = TimeHelper.sum_ts_diff(dates, 0)
    assert diffs == true_values
    {:ok, avg_diffs} = GitHelper.get_avg_tag_commit_time_diff(dates)

    true_avg_diffs = [
      1_412_612.8421052631,
      2_111_112.533333333,
      34.0,
      43683.38888888889,
      406_975.56842105265,
      106_289.25438596492,
      2_696_427.242424242,
      1_814_514.1666666667,
      1_401_570.1960784313,
      29449.522727272728,
      26.5,
      25537.571428571428,
      196_416.1052631579,
      180_621.63888888888,
      392_884.0
    ]

    assert true_avg_diffs == avg_diffs
  end

  test "get code changes in last 2 commits", context do
    {:ok, tag_commits} = GitModule.get_last_n_commits(context[:tag_repo], 2)
    {:ok, tag_diffs} = GitModule.get_diff_2_commits(context[:tag_repo], tag_commits)
    {:ok, tag_files_changed, tag_insertions, tag_deletions} = GitHelper.parse_diff(tag_diffs)
    assert tag_files_changed == 3
    assert tag_insertions + tag_deletions == 27
    assert GitModule.get_total_lines(context[:tag_repo]) == {:ok, 15793, 119}

    {:ok, commits} = GitModule.get_last_n_commits(context[:repo], 2)
    {:ok, diffs} = GitModule.get_diff_2_commits(context[:repo], commits)
    {:ok, files_changed, insertions, deletions} = GitHelper.parse_diff(diffs)
    assert files_changed == 1
    assert insertions + deletions == 2
    assert GitModule.get_total_lines(context[:repo]) == {:ok, 543, 10}

    {:ok, bb_commits} = GitModule.get_last_n_commits(context[:bitbucket_repo], 2)
    {:ok, bb_diffs} = GitModule.get_diff_2_commits(context[:bitbucket_repo], bb_commits)
    {:ok, bb_files_changed, bb_insertions, bb_deletions} = GitHelper.parse_diff(bb_diffs)
    assert bb_files_changed == 1
    assert bb_insertions + bb_deletions == 41
    assert GitModule.get_total_lines(context[:bitbucket_repo]) == {:ok, 512, 10}

    {:ok, gl_commits} = GitModule.get_last_n_commits(context[:gitlab_repo], 2)
    {:ok, gl_diffs} = GitModule.get_diff_2_commits(context[:gitlab_repo], gl_commits)
    {:ok, gl_files_changed, gl_insertions, gl_deletions} = GitHelper.parse_diff(gl_diffs)
    assert gl_files_changed == 1
    assert gl_insertions + gl_deletions == 3
    assert GitModule.get_total_lines(context[:gitlab_repo]) == {:ok, 1260, 35}
  end

  test "get contributor counts", context do
    {:ok, contributor_distribution, total} =
      GitModule.get_contributor_distribution(context[:repo])

    values = Map.values(contributor_distribution)
    assert total == 7
    assert values == [1, 6]
    assert Map.fetch(contributor_distribution, "Kit Plummer <kplummer@blitz.local>") == {:ok, 6}

    {:ok, t_contributor_distribution, t_total} =
      GitModule.get_contributor_distribution(context[:tag_repo])

    assert Map.values(t_contributor_distribution) == [
             1,
             24,
             1,
             4,
             2,
             1,
             2,
             1,
             234,
             1,
             4,
             1,
             204,
             1,
             1,
             9,
             19,
             1,
             1,
             1,
             1,
             1,
             1,
             3,
             3,
             2
           ]

    assert t_total == 524

    {:ok, bb_contributor_distribution, bb_total} =
      GitModule.get_contributor_distribution(context[:bitbucket_repo])

    assert Map.values(bb_contributor_distribution) == [3, 29]
    assert bb_total == 32

    {:ok, gl_contributor_distribution, gl_total} =
      GitModule.get_contributor_distribution(context[:gitlab_repo])

    assert Map.values(gl_contributor_distribution) == [
             1,
             3,
             1,
             11,
             1,
             12,
             1,
             14,
             4,
             1,
             1,
             4,
             11,
             5,
             7,
             5,
             3,
             1,
             11,
             11,
             2,
             35,
             1,
             6,
             2,
             6,
             2,
             2,
             1,
             7,
             3,
             28,
             2,
             2,
             1,
             2,
             1,
             3,
             6,
             1,
             22,
             5,
             5,
             1,
             1,
             2,
             24
           ]

    assert gl_total == 281
  end

  test "get the number of contributors over a certain percentage", context do
    {:ok, number, _contributor_names} = GitModule.get_functional_contributors(context[:repo])
    assert number == 1

    {:ok, number, _contributor_names} = GitModule.get_functional_contributors(context[:tag_repo])
    assert number == 3

    {:ok, number, _contributor_names} =
      GitModule.get_functional_contributors(context[:gitlab_repo])

    assert number == 15

    {:ok, number, _contributor_names} =
      GitModule.get_functional_contributors(context[:bitbucket_repo])

    assert number == 1
  end

  test "get local path repo" do
    {:ok, repo} = GitModule.get_repo(".")
    assert "." == repo.path
  end

  test "error on not a valid local path repo" do
    {:error, msg} = GitModule.get_repo("/tmp")
    assert 128 == msg.code
  end

  test "get repo size", %{repo: repo} do
    {:ok, size} = GitModule.get_repo_size(repo)
    assert nil != size
    assert "" != size
  end

  test "subgroup repo from gitlab", %{gitlab_subgroup_repo: gitlab_subgroup_repo} do
    {:ok, size} = GitModule.get_repo_size(gitlab_subgroup_repo)
    assert nil != size
  end

  test "repo with a no name committer" do
    log =
      " <feihai@DESKTOP-5974P1K.localdomain> (10):\n      增加或删除端口时，重新加载并显示当前端口状态\n      modify package.json\n      add 4docker_admin\n      4port 添加udp支持；添加trace iptables的 addtrace 和 rmtrace命令\n      4port 添加udp支持；添加trace iptables的 addtrace 和 rmtrace命令\n      4port 添加udp支持；添加trace iptables的 addtrace 和 rmtrace命令\n      4port 添加udp支持；添加trace iptables的 addtrace 和 rmtrace命令\n      4port 添加udp支持；添加trace iptables的 addtrace 和 rmtrace命令\n      4port trace 开启内核模块\n      !\n\nqiufeihai <308350718@qq.com> (9):\n      Initial commit\n      init\n      .\n      add 4npm 切换npm源\n      fix bug\n      x\n      add 4tar 4lrzsz\n      add 4tar 4lrzsz\n      加注释和解除注释脚本4comment 4uncomment\n\nroot <root@DESKTOP-G3C2S9M.localdomain> (5):\n      !\n      4port addtrace add source\n      !\n      add 4check_cert 4http\n      add 4check_cert 4http\n\nroot <root@DESKTOP-5974P1K.localdomain> (3):\n      add 4port\n      add 4sshport\n      update package.json\n\n"

    contributors = GitHelper.parse_shortlog(log)
    assert 4 == Enum.count(contributors)
  end
end
