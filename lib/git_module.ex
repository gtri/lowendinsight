# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GitModule do
  @moduledoc """
  Collections of functions for interacting with the `git` command to perform queries.
  """
  require Logger

  @doc """
  clone_repo/2: clones the repo
  """
  @spec clone_repo(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clone_repo(url, tmp_path) do
    {:ok, slug} = url |> Helpers.get_slug()
    {:ok, _, repo_name} = Helpers.split_slug(slug)

    ## repo_name needs to go to a tmp path struct
    tmp_repo_path = Path.join(tmp_path, repo_name)

    with {:ok, repo} <- Git.clone([url, tmp_repo_path]),
         {:ok, _} <- Git.log(repo) do
      {:ok, repo}
    else
      _error -> {:error, "Repository not found"}
    end
  end

  @doc """
  get_repo/1: gets a repo by path, returns Repository struct
  """
  @spec get_repo(String.t()) :: {:ok, Git.Repository.t()} | {:error, String.t()}
  def get_repo(path) do
    with repo <- Git.new(path),
         {:ok, _} <- Git.status(repo) do
      {:ok, repo}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @doc """
  get_contributors_count/1: returns the number of contributors for
  a given Git repo
  """
  @spec get_contributor_count(Git.Repository.t()) :: {:ok, non_neg_integer}
  def get_contributor_count(repo) do
    count =
      Git.shortlog!(repo, ["-s", "-n", "HEAD", "--"])
      |> String.trim()
      |> String.split(~r{\s\s+})
      |> Enum.count()

    {:ok, count}
  end

  @doc """
  get_last_commit_date/1: returns the date of the last commit
  """
  @spec get_last_commit_date(Git.Repository.t()) :: {:ok, String.t()}
  def get_last_commit_date(repo) do
    date = List.last(git_log_split(repo, ["-1", "--pretty=format:%cI"]))
    {:ok, date}
  end

  @spec delete_repo(
          atom
          | %{
              :path =>
                binary
                | maybe_improper_list(
                    binary | maybe_improper_list(any, binary | []) | char,
                    binary | []
                  ),
              optional(any) => any
            }
        ) :: [binary]
  def delete_repo(repo) do
    File.rm_rf!(repo.path)
  end

  @doc """
  get_current_hash/1: returns the hash of the repo's HEAD
  """
  @spec get_hash(Git.Repository.t()) :: {:ok, String.t()}
  def get_hash(repo) do
    hash = Git.rev_parse!(repo, "HEAD") |> String.trim()
    {:ok, hash}
  end

  @doc """
  get_default_branch/1: returns the default branch of the remote repo
  """
  @spec get_default_branch(Git.Repository.t()) :: {:ok, String.t()}
  def get_default_branch(repo) do
    try do
      default_branch = Git.symbolic_ref!(repo, "refs/remotes/origin/HEAD") |> String.trim()
      {:ok, default_branch}
    rescue
      _e in Git.Error -> {:ok, "undeterminable, not at HEAD"}
    end
  end

  @doc """
  get_total_commit_count/2: returns the count of commits for a provided branch
  """
  def get_total_commit_count(repo, branch) do
    count = Git.rev_list!(repo, ["--count", branch]) |> String.trim_trailing() |> String.to_integer()
    {:ok, count}
  end

  @doc """
  get_commit_dates/1: returns a list of unix timestamps representing commit times
  """
  @spec get_commit_dates(Git.Repository.t()) :: {:ok, [non_neg_integer]}
  def get_commit_dates(repo) do
    dates = git_log_split(repo, ["--pretty=format:%ct"])

    dates_int = Enum.map(dates, fn x -> String.to_integer(x, 10) end)
    {:ok, dates_int}
  end

  @spec get_tag_and_commit_dates(Git.Repository.t()) :: {:ok, [[...]]}
  @doc """
  get_tag_and_commit_dates/1: returns a list of lists of unix timestamps
  representing commit times with each lsit belonging to a different tag
  """
  def get_tag_and_commit_dates(repo) do
    tag_and_date =
      git_log_split(repo, ["--pretty=format:%d$%ct"])
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
  @spec get_last_n_commits(Git.Repository.t(), non_neg_integer) :: {:ok, [any]}
  def get_last_n_commits(repo, n) do
    output = git_log_split(repo, ["--pretty=format:%h", "--no-merges", "-#{n}"])
    {:ok, output}
  end

  @doc """
  get_last_n_commits/2: returns a list of lines generated from the diff of two commits
  """
  @spec get_diff_2_commits(Git.Repository.t(), [any]) :: {:ok, [String.t()]} | []
  def get_diff_2_commits(repo, [commit1 | [commit2 | []]]) do
    with {:ok, diff} <- Git.diff(repo, ["--stat", commit1, commit2]) do
      {:ok, String.split(String.trim_trailing(diff, "\n"), "\n")}
    else
      _ -> []
    end
  end

  @doc """
  get_total_lines/1: returns the total lines and files contained in a repo as of the latest commit
  """
  @spec get_total_lines(Git.Repository.t()) :: {:ok, non_neg_integer, non_neg_integer}
  def get_total_lines(repo) do
    {:ok, hash} = Git.hash_object(repo, ["-t", "tree", "/dev/null"])
    {:ok, diff} = Git.diff(repo, ["--shortstat", String.replace_suffix(hash, "\n", "")])
    [files_changed | [lines_changed | _tail]] = String.split(diff, ", ")
    [file_num | _tail] = String.split(String.trim(files_changed), " ")
    [line_num | _tail] = String.split(lines_changed, " ")
    {:ok, String.to_integer(line_num), String.to_integer(file_num)}
  end

  @spec get_recent_changes(Git.Repository.t()) :: {:ok, number, number}
  @doc """
  get_recent_changes/1: returns the percentage of changed lines in the last commit by the total lines in the repo
  """
  def get_recent_changes(repo) do
    with {:ok, total_lines, total_files_changed} <- get_total_lines(repo),
         {:ok, file_num, insertions, deletions} = get_last_2_delta(repo) do
      if total_lines == 0 do
        {:ok, 0, 0}
      else
        {:ok, Float.round((insertions + deletions) / total_lines, 5),
         Float.round(file_num / total_files_changed, 5)}
      end
    end
  end

  @doc """
  get_last_2_delta/1: returns the lines changed, files changed, additions and deletions in the last commit
  """
  @spec get_last_2_delta(Git.Repository.t()) ::
          {:ok, non_neg_integer, non_neg_integer, non_neg_integer}
  def get_last_2_delta(repo) do
    {:ok, commits} = get_last_n_commits(repo, 2)

    cond do
      length(commits) >= 2 ->
        {:ok, diffs} = get_diff_2_commits(repo, commits)

        if diffs == [""] do
          {:ok, 0, 0, 0}
        else
          GitHelper.parse_diff(diffs)
        end

      length(commits) < 2 ->
        {:ok, 0, 0, 0}
    end
  end

  @spec get_contributors(Git.Repository.t()) :: {:ok, [Contributor.t()]}
  def get_contributors(repo) do
    list =
      Git.shortlog!(repo, ["-n", "-e", "HEAD", "--"])
      |> String.codepoints()
      |> Enum.map(fn x ->
        if !String.valid?(x) do
          Enum.join(for <<c <- x>>, do: <<c::utf8>>)
        else
          x
        end
      end)
      |> Enum.join()
      |> GitHelper.parse_shortlog()

    {:ok, list}
  end

  @spec get_contributor_distribution(Git.Repository.t()) :: {:ok, map, non_neg_integer}
  def get_contributor_distribution(repo) do
    {:ok, contributors} = get_contributors(repo)
    # Helper function
    get_counts = fn contrib -> contrib.count end
    get_signoff = fn contrib -> contrib.name <> " <" <> contrib.email <> ">" end
    # Calcualte for eache
    counts_kwlist = for a <- contributors, do: {get_signoff.(a), get_counts.(a)}
    counts = Enum.into(counts_kwlist, %{})
    # Calculate for all
    total_contributions = Enum.sum(for a <- contributors, do: get_counts.(a))
    {:ok, counts, total_contributions}
  end

  @spec get_functional_contributors(Git.Repository.t()) :: {:ok, non_neg_integer, [any]}
  def get_functional_contributors(repo) do
    {:ok, counts, total} = get_contributor_distribution(repo)
    {:ok, length, filtered_list} = GitHelper.get_filtered_contributor_count(counts, total)
    {:ok, length, Enum.map(filtered_list, fn {name, _value} -> name end)}
  end

  @doc """
  get_contributions_map/1: returns a map of contributions per git user
  note: this map is unfiltered, dupes aren't identified
  """
  @spec get_contributions_map(Git.Repository.t()) ::
          {:ok, [%{contributions: non_neg_integer, name: String.t()}]}
  def get_contributions_map(repo) do
    {:ok, contrib} = get_contributors(repo)

    map =
      Enum.map(
        contrib,
        fn x -> %{:name => x.name,
                  :contributions => x.count,
                  :last_contribution_date => get_last_contribution_date_by_contributor(repo, x.name)
                  } end
      )

    {:ok, map}
  end

  @spec get_clean_contributions_map(Git.Repository.t()) :: {:ok, list}
  def get_clean_contributions_map(repo) do
    map =
      Git.shortlog!(repo, ["-n", "-e", "HEAD", "--"])
      |> GitHelper.parse_shortlog()
      |> Enum.map(fn contributor ->
        name =
          cond do
            contributor.name == nil -> "UNKNOWN"
            contributor.name == "" -> "UNKNOWN"
            contributor.name != "" -> raw_binary_to_string(contributor.name)
          end

        %{
          name: raw_binary_to_string(name),
          contributions: contributor.count,
          merges: contributor.merges,
          email: contributor.email,
          last_contribution_date: contributor.last_contribution_date
        }
      end)

    {:ok, map}
  end

  @doc """
      get_top10_contributors_map/1: Gets the top 10 contributors and returns it
      as a list of contributors with the commits list stripped from the map.
  """
  @spec get_top10_contributors_map(Git.Repository.t()) :: {:ok, [any]}
  def get_top10_contributors_map(repo) do
    {:ok, contrib} = get_contributors(repo)

    map10 =
      Enum.sort_by(contrib, & &1.count, &>=/2)
      |> Stream.take(10)
      |> Stream.map(fn x ->
        Map.put(x, :contributions, x.count)
      end)
      |> Stream.map(fn x ->
        Map.put(x, :last_contribution_date, get_last_contribution_date_by_contributor(repo, x.name))
      end)
      |> Stream.map(fn x ->
        Map.drop(x, [:commits, :count, :__struct__])
      end)
      |> Enum.to_list()

    {:ok, map10}
  end

  @doc """
  get_last_contribution_date_by_contributor/1: returns the date of the last author or commit whichever
  is more recent.
  """
  def get_last_contribution_date_by_contributor(repo, contributor) do
    ## Using author here, as even if there is a different committer, the author is the contributor
    author_date = List.last(git_log_split(repo, ["--author=#{contributor}", "-1", "--pretty=format:%cI"]))
    author_date
  end

  @spec get_repo_size(Git.Repository.t()) :: {:ok, String.t()}
  def get_repo_size(repo) do
    space =
      elem(System.cmd("git", ["count-objects"], cd: repo.path), 0)
      |> String.trim()
      |> String.split(",")
      |> Enum.at(1)
      |> String.trim()
      |> String.split(" ")
      |> List.first()

    {:ok, space}
  end

  @spec raw_binary_to_string(binary) :: String.t()
  defp raw_binary_to_string(raw) do
    String.codepoints(raw)
    |> Enum.reduce(fn w, result ->
      cond do
        String.valid?(w) ->
          result <> w

        true ->
          <<parsed::8>> = w
          result <> <<parsed::utf8>>
      end
    end)
  end

  # This is a replacement for Git.log!() and String.split() to split out warning tags.
  # Unless we can find a command for Git.log! which can separate out "warning:" tags,
  # we need to manually parse it out here

  @spec git_log_split(Git.Repository.t(), [String.t()]) :: [String.t()]
  defp git_log_split(repo, args) do
    Git.log!(repo, args)
    |> String.split("\n")
    |> Enum.filter(fn x ->
      if not String.contains?(x, "warning:") do
        x
      end
    end)
  end
end
