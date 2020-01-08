# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Helpers do
  @moduledoc """
  Collection of generic helper functions.
  """

  @doc """
  get_slug/1: extracts the slug from the provided URI argument and returns the path

  # Example
      iex(1)> {:ok, slug} = Helpers.get_slug("https://github.com/kitplummer/xmpprails")
      {:ok, "kitplummer/xmpprails"}
      iex(2)> slug
      "kitplummer/xmpprails"
  """
  def get_slug(url) do
    uri = URI.parse(url)

    case uri.path do
      nil ->
        {:error, "invalid source URL"}

      path ->
        path = String.slice(path, 1..-1)
        {:ok, path}
    end
  end

  @doc """
  split_slug/1: splits apart the username and repo from a git slug returning discrete stings.

  ## Examples

      iex(6)> {:ok, org, repo}  = Helpers.split_slug("kitplummer/xmpprails")
      {:ok, "kitplummer", "xmpprails"}
      iex(7)> org
      "kitplummer"
      iex(8)> repo
      "xmpprails"

  """
  def split_slug(slug) do
    if String.contains?(slug, "/") do
      v = String.split(slug, "/")
      {:ok, Enum.at(v, 0), Enum.at(v, 1)}
    else
      {:error, "bad_slug"}
    end
  end

  def count_forward_slashes(url) do
    url |> String.graphemes |> Enum.count(& &1 == "/")
  end

  # def have_config() do
  #   try do
  #     config = Application.fetch_env!(:lowendinsight, :critical_contributor_level)
  #     IO.inspect config
  #     IO.puts "CONFIG: "

  #   rescue
  #     RuntimeError -> raise ArgumentError, message: "No LoweEndInsight configuration found."
  #   end
  # end

end
