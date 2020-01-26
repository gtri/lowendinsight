# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GitModule do
  @moduledoc """
  Collections of functions for interacting with the `git` command to perform queries.
  """

  @doc """
  clone/1: clones the repo
  """

  def clone_repo(url) do
    {:ok, slug} = url |> Helpers.get_slug
    {:ok, _, repo_name} = Helpers.split_slug slug

    response = Git.clone([url, repo_name])
    case response do
      {:ok, repo} ->
        {:ok, repo}

      {:error, _error} ->
        # This error message is not always appropriate
        {:error, "Repository not found"}
    end
  end

  @doc """
  get_contributors_count/1: returns the number of contributors for
  a given Git repo
  """

  def get_contributor_count(repo) do
    count =
      Git.shortlog!(repo, ["-s", "-n", "HEAD"])
      |> String.trim()
      |> String.split(~r{\s\s+})
      |> Enum.count()

    {:ok, count}
  end

  @doc """
  get_last_commit_date/1: returns the date of the last commit
  """

  def get_last_commit_date(repo) do
    date = Git.log!(repo, ["-1", "--pretty=format:%cI"])
    {:ok, date}
  end

  def delete_repo(repo) do
    File.rm_rf!(repo.path)
  end

  @doc """
  get_commit_dates/1: returns a list of unix timestamps representing commit times
  """
  def get_commit_dates(repo) do
    dates =
      Git.log!(repo, ["--pretty=format:%ct"])
      |> String.split("\n")

    dates_int = Enum.map(dates, fn x -> String.to_integer(x, 10) end)
    {:ok, dates_int}
  end

  @doc """
  get_tag_and_commit_dates/1: returns a list of lists of unix timestamps
  representing commit times with each lsit belonging to a different tag
  """
  def get_tag_and_commit_dates(repo) do
    tag_and_date =
      Git.log!(repo, ["--pretty=format:%d$%ct"])
      |> String.split("\n")
      |> Enum.map(fn element -> String.split(element, "$") end)
      |> Enum.map(fn [head | tail] ->
        if head == "" do
          ["" | String.to_integer(Enum.at(tail, 0), 10)]
        else
          [
            String.trim(String.trim(String.trim(head), "("), ")")
            | String.to_integer(Enum.at(tail, 0), 10)
          ]
        end
      end)

    GitHelper.split_commits_by_tag(tag_and_date)
  end

  @doc """
  get_last_n_commits/1: returns a list of the short hashes of the last n commits
  """
  def get_last_n_commits(repo, n) do
    output = Git.log!(repo, ["--pretty=format:%h", "--no-merges", "-#{n}"])
    {:ok, String.split(output, "\n")}
  end

  @doc """
  get_last_n_commits/2: returns a list of lines generated from the diff of two commits
  """
  def get_diff_2_commits(repo, [commit1 | [commit2 | []]]) do
    {:ok, diff} = Git.diff(repo, ["--stat", commit1, commit2])
    {:ok, String.split(String.trim_trailing(diff, "\n"), "\n")}
  end

  @doc """
  get_total_lines/1: returns the total lines and files contained in a repo as of the latest commit
  """
  def get_total_lines(repo) do
    {:ok, hash} = Git.hash_object(repo, ["-t", "tree", "/dev/null"])
    {:ok, diff} = Git.diff(repo, ["--shortstat", String.replace_suffix(hash, "\n", "")])
    [files_changed | [lines_changed | _tail]] = String.split(diff, ", ")
    [file_num | _tail] = String.split(String.trim(files_changed), " ")
    [line_num | _tail] = String.split(lines_changed, " ")
    {:ok, String.to_integer(line_num), String.to_integer(file_num)}
  end

  @doc """
  get_recent_changes/1: returns the fraction of changed lines in the last commit by the total lines in the repo
  """
  def get_recent_changes(repo) do
    {:ok, total_lines, total_files_changed} = get_total_lines(repo)
    {:ok, file_num, insertions, deletions} = get_last_2_delta(repo)
    {:ok, (insertions + deletions) / total_lines, file_num / total_files_changed}
  end

  @doc """
  get_last_2_delta/1: returns the lines changed, files changed, additions and deletions in the last commit
  """
  def get_last_2_delta(repo) do
    {:ok, commits} = get_last_n_commits(repo, 2)
    {:ok, diffs} = get_diff_2_commits(repo, commits)
    GitHelper.parse_diff(diffs)
  end

  def get_contributor_distribution(repo) do
    contributors = Git.log!(repo, ["--pretty=format:%an"])
    contributors_list = String.split(contributors, "\n")
    total_contributions = Kernel.length(contributors_list)
    {:ok, counts} = GitHelper.get_contributor_counts(contributors_list)
    {:ok, counts, total_contributions}
  end

  def get_functional_contributors(repo) do
    {:ok, counts, total} = get_contributor_distribution(repo)
    {:ok, length, filtered_list} = GitHelper.get_filtered_contributor_count(counts, total)
    {:ok, length, Enum.map(filtered_list, fn {name, _value} -> name end)}
  end

  @doc """
  get_contributions_map/1: returns a map of contributions per git user
  note: this map is unfiltered, dupes aren't identified
  """
  def get_contributions_map(repo) do
    map = Git.shortlog!(repo, ["-s", "-n", "HEAD"])
    |> String.trim()
    |> String.split(~r{\s\s+})
    |> Enum.map(fn x ->
      s = String.split(x, "\t")
      ## Found that there can be bad entries in the git log, just ignore
      if String.contains?(x, "\t") do
        k = Enum.at(s, 1)
        v = String.to_integer(Enum.at(s, 0))
        %{k => v}
      end
    end)
    {:ok, map}
  end

  def get_top10_contributors_map(repo) do
    {:ok, map} = get_contributions_map(repo)
    map10 = Enum.take(map, 10) 
    {:ok, map10}
  end
end
