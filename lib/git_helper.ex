# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GitHelper do
  @moduledoc """
  Collection of lower-level functions for analyzing outputs from git command.
  """

  @type contrib_count :: %{String.t() => integer}

  @doc """
      parse_diff/1: returns the relevant information contained in the last array position of a diff array
  """
  def parse_diff(list) do
    last = List.last(list)
    last_trimmed = String.trim(last)
    commit_info = String.split(last_trimmed, ", ")
    file_string = Enum.at(commit_info, 0)

    if file_string == nil do
      {:ok, 0, 0, 0}
    else
      insertion_string = Enum.at(commit_info, 1)

      if insertion_string == nil do
        [file_num | _tail] = String.split(file_string, " ")
        {:ok, String.to_integer(file_num), 0, 0}
      else
        deletion_string = Enum.at(commit_info, 2)

        if deletion_string == nil do
          [file_num | _tail] = String.split(file_string, " ")
          [insertion_num | _tail] = String.split(insertion_string, " ")
          {:ok, String.to_integer(file_num), String.to_integer(insertion_num), 0}
        else
          [file_num | _tail] = String.split(file_string, " ")
          [insertion_num | _tail] = String.split(insertion_string, " ")
          [deletion_num | _tail] = String.split(deletion_string, " ")

          {:ok, String.to_integer(file_num), String.to_integer(insertion_num),
           String.to_integer(deletion_num)}
        end
      end
    end
  end

  @doc """
      get_avg_tag_commit_tim_diff/1: return the average time between commits within each subarray representing a tag
  """
  def get_avg_tag_commit_time_diff(list) do
    get_avg_tag_commit_time_diff(list, [])
  end

  @doc """
      get_total_tag_commit_time_diff/1: return the total time between commits within each subarray representing a tag
  """
  def get_total_tag_commit_time_diff(list) do
    get_total_tag_commit_time_diff(list, [])
  end

  @doc """
      split_commits_by_tag/1: returns a list with sublists arranged by tag
  """
  def split_commits_by_tag(list) do
    split_commits_by_tag(list, [])
  end

  @doc """
      get_contributor_counts/1: Gets the number of contributions belonging to each author and return a map of %{name => number}
  """
  def get_contributor_counts(list) do
    get_contributor_counts(list, %{})
  end

  @doc """
      det_filtered_contributor_count/2: Gets the resolved list of contributers, return count and list
  """
  @spec get_filtered_contributor_count(contrib_count, non_neg_integer) ::
          {:ok, non_neg_integer, [contrib_count]}
  def get_filtered_contributor_count(map, total) do
    filtered_list =
      Enum.filter(
        map,
        fn {_key, value} ->
          value / total >= 1 / Kernel.map_size(map)
        end
      )

    length = Kernel.length(filtered_list)
    {:ok, length, filtered_list}
  end

  @spec parse_shortlog(binary) :: [Contributor.t()]
  def parse_shortlog(log) do
    split_shortlog(log)
    |> Enum.map(fn contributor ->
      {name, email, count} = parse_header(contributor)
      {merges, commits} = parse_commits(contributor)

      {count, _} = Integer.parse(count)

      %Contributor{
        name: String.trim(name),
        email: String.trim(email),
        count: count,
        merges: merges,
        commits: commits
      }
    end)
    |> filter_contributors()
  end

  defp split_shortlog(log) do
    log
    |> String.trim()
    |> String.split(~r{\n\n})
  end

  defp parse_header(contributor) do
    header =
      contributor
      |> String.split("\n")
      |> Enum.at(0)
      |> (&Regex.scan(~r{([^<]+)<([^;]*)>.\(([^:]+)\)}, &1)).()
      |> Enum.at(0)

    {Enum.at(header, 1), Enum.at(header, 2), Enum.at(header, 3)}
  end

  defp parse_commits(contributor) do
    [_ | commits] = String.split(contributor, "\n")

    commits = Enum.map(commits, fn commit -> String.trim(commit) end)
    merges = Enum.count(commits, &(&1 =~ ~r/^(merge)+/i))
    {merges, commits}
  end

  defp split_commits_by_tag([], current) do
    {:ok, current}
  end

  defp split_commits_by_tag([first | rest], []) do
    split_commits_by_tag(rest, [[first]])
  end

  defp split_commits_by_tag([first | rest], current) do
    [head | _tail] = first

    if String.contains?(head, "tag") do
      new_current = [[first] | current]
      split_commits_by_tag(rest, new_current)
    else
      [current_head | current_tail] = current
      new_current = [[first | current_head] | current_tail]
      split_commits_by_tag(rest, new_current)
    end
  end

  defp get_total_tag_commit_time_diff([first | tail], accumulator) do
    {:ok, time} = TimeHelper.sum_ts_diff(first)
    ret = [time | accumulator]
    get_total_tag_commit_time_diff(tail, ret)
  end

  defp get_total_tag_commit_time_diff([], accumulator) do
    {:ok, accumulator}
  end

  defp get_avg_tag_commit_time_diff([first | tail], accumulator) do
    {:ok, time} = TimeHelper.sum_ts_diff(first)
    ret = [time / Kernel.length(first) | accumulator]
    get_avg_tag_commit_time_diff(tail, ret)
  end

  defp get_avg_tag_commit_time_diff([], accumulator) do
    {:ok, accumulator}
  end

  @spec get_contributor_counts([any], contrib_count) :: {:ok, [contrib_count], non_neg_integer}
  defp get_contributor_counts([head | tail], accumulator) do
    if head == "" do
      get_contributor_counts(tail, accumulator)
    else
      maybe_new_key = Map.put_new(accumulator, String.trim(head), 0)

      {_num, new_value} =
        Map.get_and_update(maybe_new_key, head, fn current_value ->
          if current_value == nil do
            {0, 1}
          else
            {current_value, current_value + 1}
          end
        end)

      get_contributor_counts(tail, new_value)
    end
  end

  defp get_contributor_counts([], accumulator) do
    {:ok, accumulator}
  end

  defp name_sorter(x) do
    # Create a name metric to compare with
    10 * length(String.split(x, " ")) + String.length(x)
  end

  defp filter_contributors([]) do
    []
  end

  @spec filter_contributors([Contributor.t()]) :: [Contributor.t()]
  defp filter_contributors(list) do
    is_author = fn x, y -> String.downcase(x.email) == String.downcase(y.email) end
    # Divide the list
    cur_contrib = for item <- list, is_author.(item, hd(list)) == true, do: item
    other = for item <- list, is_author.(item, hd(list)) == false, do: item
    # Determine the best name
    #   for now, just the first one
    name_list = for a <- cur_contrib, do: a.name

    best_name =
      Enum.sort_by(name_list, &name_sorter/1, &>=/2)
      |> Enum.at(0)

    # Create the new contributor object
    contrib_ret = %Contributor{
      name: best_name,
      email: hd(list).email,
      commits: List.flatten(for a <- cur_contrib, do: a.commits),
      merges: Enum.sum(for a <- cur_contrib, do: a.merges),
      count: Enum.sum(for a <- cur_contrib, do: a.count)
    }

    [contrib_ret | filter_contributors(other)]
  end
end
