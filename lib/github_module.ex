# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GithubModule do
  @moduledoc """
  Documentation for GithubModule.
  """

  @doc """
  get_contributors_count: returns the number of contributors to a repo

  """
  def get_contributors_count(slug) do
    {:ok, org, repo} = Helpers.split_slug(slug)

    c =
      Tentacat.Client.new(%{access_token: Application.fetch_env!(:lowendinsight, :access_token)})

    contributors = Tentacat.Repositories.Contributors.list(c, org, repo)

    if elem(contributors, 0) == 404 do
      {:error, "repo not found"}
    else
      {:ok, elem(contributors, 1) |> Enum.count()}
    end
  end

  @doc """
  get_last_commit_delta: returns the number of days since the last commit

  """
  def get_last_commit_date(slug) do
    {:ok, org, repo} = Helpers.split_slug(slug)

    c =
      Tentacat.Client.new(%{access_token: Application.fetch_env!(:lowendinsight, :access_token)})

    commits = Tentacat.Commits.list(c, org, repo)

    if elem(commits, 0) == 404 do
      {:error, "repo not found"}
    else
      commit = elem(commits, 1) |> List.first()
      {:ok, date, _something} = DateTime.from_iso8601(commit["commit"]["committer"]["date"])
      {:ok, date}
    end
  end
end
